module Merb
  module TicketsHelper

    def update_field(prop)
      "#{property_update(prop)} is change from '#{old_field(prop)}' to '#{new_field(prop)}'"
    end

    def property_update(prop)
      case prop[0]
      when :state_id
        "Status"
      when :tag_list
        "Tag"
      when :member_assigned_id
        "Responsible"
      when :title
        "Title"
      when :priority_id
        "Priority"
      end
    end

    def old_field(prop)
      transform_field(prop[0], prop[1])
    end

    def new_field(prop)
      transform_field(prop[0], prop[2])
    end

    def transform_field(state, field)
      return "" if field.nil?
      case state
      when :state_id
        State.get(field).name
      when :tag_list
        field
      when :member_assigned_id
        m = User.get(field)
        if m.nil?
          ""
        else
          m.login
        end
      when :title
        field
      when :priority_id
        s = Priority.get(field)
        if s.nil?
          ""
        else
          s.name
        end
      end
    end

  end
end # Merb
