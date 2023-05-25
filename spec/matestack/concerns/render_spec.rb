# frozen_string_literal: true

describe Render do
  describe "#render" do
    describe "called on a class that includes Render" do
      subject(:render) { renderable_class.new.render }

      let(:renderable_class) do
        Class.new do
          include Render
        end
      end

      it "returns requires a body method" do
        expect { render }.to raise_error(NoMethodError, /body/)
      end
    end

    describe "called on a class that includes Render and defines a body method" do
      subject(:render) { renderable_class.new.render }

      let(:renderable_class) do
        Class.new do
          include Render

          def body
            "Hello World"
          end
        end
      end

      it "returns the body method" do
        expect(render).to eq("Hello World")
      end
    end
  end
end
