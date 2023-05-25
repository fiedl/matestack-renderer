# frozen_string_literal: true

# This class defines the `Matestack::RenderBuffer`, a container for chaining html snippets together that
# are provided by matestack components or rails view helpers.
#
# Withint the render buffer, one could collect the snippets like this:
#
#     class MyPage
#       def body
#         html_snippets = []
#         html_snippets << heading text: "Hello world!"
#         html_snippets << button text: "Hello to you, too!"
#         html_snippets.join("\n")
#       end
#     end
#
#     def render(page)
#       page.new.body
#     end
#
#     render MyPage  # => "<h1>Hello world!</h1>
#                    #     <button>Hello to you, too!</button>"
#
# Using the render-buffer mechanism, the same could be achieved with this body definition,
# making the html-snippet collection implicit, later:
#
#     def body
#       heading text: "Hello world!"
#       button text: "Hello to you, too!"
#     end
#
#
# This is how this class is used directly:
#
#     separate_buffer = Matestack::RenderBuffer.new
#     outer_buffer = Matestack::RenderBuffer.new
#     inner_buffer = Matestack::RenderBuffer.new
#
#     separate_buffer.collect do
#       Matestack::RenderBuffer.add "Content added outside of outer_buffer and inner_buffer"
#     end
#     outer_buffer.collect do
#       Matestack::RenderBuffer.add "Foo added within outer_buffer"
#       inner_buffer.collect do
#         Matestack::RenderBuffer.add "Bar added within inner_buffer nested within outer_buffer"
#       end
#       Matestack::RenderBuffer.add "Baz added within outer_buffer"
#     end
#
#     separate_buffer.result # => "Content added outside of outer_buffer and inner_buffer"
#     outer_buffer.result    # => "Foo added within outer_buffer
#                            #     Baz added within outer_buffer"
#     inner_buffer.result    # => "Bar added within inner_buffer nested within outer_buffer"
#
class Matestack::RenderBuffer
  def initialize
    @strings = []
  end

  def self.collect(&block)
    new.collect(&block).html_safe
  end

  def collect
    last_render_buffer = self.class.current_render_buffer
    self.class.current_render_buffer = self
    result = yield
    self.class.current_render_buffer.add result if result.present? && self.class.current_render_buffer.empty?
    self.result
  ensure
    self.class.current_render_buffer = last_render_buffer
  end

  def self.add(string)
    if current_render_buffer.nil?
      raise Matestack::Renderer::Exception,
            "No current_render_buffer defined. Use RenderBuffer.add only inside RenderBuffer.collect blocks."
    end

    current_render_buffer.add string
  end

  def add(string)
    @strings << string
    string.html_safe
  end

  def result
    @strings.join("\n").html_safe
  end

  def empty?
    @strings.none?
  end

  def last_entry
    @strings.last
  end

  class << self
    attr_reader :current_render_buffer
  end

  class << self
    attr_writer :current_render_buffer
  end
end
