# frozen_string_literal: true

# rubocop:disable RSpec/MultipleExpectations

describe Matestack::RenderBuffer do
  describe "#result" do
    let(:separate_buffer) { described_class.new }
    let(:outer_buffer) { described_class.new }
    let(:inner_buffer) { described_class.new }

    describe "with content added in parallel and in nested buffers" do
      before do
        separate_buffer.collect do
          described_class.add "Content added outside of outer_buffer and inner_buffer"
        end
        outer_buffer.collect do
          described_class.add "Foo added within outer_buffer"
          inner_buffer.collect do
            described_class.add "Bar added within inner_buffer nested within outer_buffer"
          end
          described_class.add "Baz added within outer_buffer"
        end
      end

      it "contains no content added outside the buffer's collect block" do
        expect(outer_buffer.result).not_to include "Content added outside of outer_buffer and inner_buffer"
        expect(inner_buffer.result).not_to include "Content added outside of outer_buffer and inner_buffer"
      end

      it "contains content added within the buffer's collect block" do
        expect(outer_buffer.result).to include "Foo added within outer_buffer"
        expect(outer_buffer.result).to include "Baz added within outer_buffer"
        expect(inner_buffer.result).to include "Bar added within inner_buffer nested within outer_buffer"
      end

      it "contains no content added within a nested collect block " \
         "because this would lead to adding the same code twice later" do
        expect(outer_buffer.result).not_to include "Bar added within inner_buffer nested within outer_buffer"
      end

      it "contains no content added within a surrounding collect block" do
        expect(inner_buffer.result).not_to include "Foo added within outer_buffer"
        expect(inner_buffer.result).not_to include "Baz added within outer_buffer"
      end
    end
  end

  describe ".add" do
    subject(:add) { described_class.add "Foo" }

    it "raises an error outside collect blocks" do
      expect { add }.to raise_error(Matestack::Renderer::Exception, /No current_render_buffer defined/)
    end

    it "adds content to the current render buffer" do
      render_buffer = described_class.new.collect do
        add
      end
      expect(render_buffer).to eq "Foo"
    end
  end

  describe "#collect" do
    subject(:collect) do
      described_class.new.collect do
        described_class.add "Foo"
        described_class.new.collect do
          described_class.add "Bar"
        end
        described_class.add "Baz"
      end
    end

    it "returns the result of its own render buffer" do
      expect(collect).to include "Foo"
      expect(collect).to include "Baz"
      expect(collect).not_to include "Bar"
    end
  end
end

# rubocop:enable RSpec/MultipleExpectations
