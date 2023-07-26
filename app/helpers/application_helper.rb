module ApplicationHelper

    def flash_class(key)
        case key.to_sym
        when :notice
            'alert-success'
        when :alert
            'alert-danger'
        else
            ''
        end
    end

end
