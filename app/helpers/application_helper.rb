module ApplicationHelper

    def flash_class(key)
        case key.to_sym
        when :notice
            { class: 'alert-success' }
        when :alert
            { class: 'alert-danger' }
        else
            {}
        end
    end

end
