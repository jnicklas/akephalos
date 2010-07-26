module Akephalos
  class Node
    def initialize(node)
      @nodes = []
      @_node = node
    end

    def checked?
      @_node.isChecked
    end

    def text
      @_node.asText
    end

    def [](name)
      @_node.hasAttribute(name.to_s) ? @_node.getAttribute(name.to_s) : nil
    end

    def value
      case tag_name
      when "select"
        if self[:multiple]
          @_node.selected_options.map { |option| option.text }
        else
          selected_option = @_node.selected_options.first
          selected_option ? selected_option.text : nil
        end
      when "textarea"
        @_node.getText
      else
        self[:value]
      end
    end

    def value=(value)
      case tag_name
      when "textarea"
        @_node.setText(value)
      when "input"
        @_node.setValueAttribute(value)
      end
    end

    def select_option(option)
      opt = @_node.getOptions.detect { |o| o.asText == option }

      opt && opt.setSelected(true)
    end

    def unselect_option(option)
      opt = @_node.getOptions.detect { |o| o.asText == option }

      opt && opt.setSelected(false)
    end

    def options
      @_node.getOptions.map { |node| Node.new(node) }
    end

    def selected_options
      @_node.getSelectedOptions.map { |node| Node.new(node) }
    end

    def fire_event(name)
      @_node.fireEvent(name)
    end

    def tag_name
      @_node.getNodeName
    end

    def visible?
      @_node.isDisplayed
    end

    def click
      @_node.click
      @_node.getPage.getEnclosingWindow.getJobManager.waitForJobs(1000)
      @_node.getPage.getEnclosingWindow.getJobManager.waitForJobsStartingBefore(1000)
    end

    def find(selector)
      nodes = @_node.getByXPath(selector).map { |node| Node.new(node) }
      @nodes << nodes
      nodes
    end
  end
end
