# frozen_string_literal: true

concern :Render do
  def render_buffer
    @render_buffer ||= Matestack::RenderBuffer.new
  end

  def render(*args, &block)
    if (component_class = args.first) && (component_class < Matestack::Component)
      render_component component_class, args.slice(1), &block
    else
      render_self
    end
  end

  def render_self
    render_buffer.collect do
      body do
        yield if block_given?
      end
    end
  end

  def render_component(component_class, args = {}, &block)
    result = component_class.new(args: args, context: context, block: block).render # TODO: do statt block
    Matestack::RenderBuffer.add result
    result
  end

  attr_reader :context
end
