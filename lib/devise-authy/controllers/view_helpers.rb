module DeviseAuthy
  module Views
    module Helpers

      def authy_request_sms_link
        link_to(
            I18n.t('request_sms', {:scope => 'devise'}),
            url_for([resource_name, :request_sms]),
            :id => "authy-request-sms-link",
            :method => :post,
            :remote => true
        )
      end

      def authy_onetouch_javascript(path, *args)
        script = <<"JS"
        $(function(){
          setInterval(function(){
            $.get('#{path}', #{args.to_json}, function(data){
              if(data.result && data.redirect_to) {
                window.location.replace(data.redirect_to);
              }

            })
          }, 5000)
        });
JS
        javascript_tag script if resource_class.authy_enable_onetouch
      end

      def authy_onetouch_javascript_verify(*args)
        authy_onetouch_javascript send(:"#{resource_name}_verify_onetouch_authy_path", *args)
      end

      def authy_onetouch_javascript_enable(*args)
        authy_onetouch_javascript send(:"#{resource_name}_enable_onetouch_authy_path", *args)
      end

      def verify_authy_form(&block)
        form_tag([resource_name, :verify_authy], :id => 'devise_authy', :class => 'authy-form', :method => :post) do
          buffer = hidden_field_tag(:"#{resource_name}_id", @resource.id)
          buffer << capture(&block)
        end
      end

      def enable_authy_form(&block)
        form_tag([resource_name, :enable_authy], :class => 'authy-form', :method => :post) do
          capture(&block)
        end
      end

      def verify_authy_installation_form(&block)
        form_tag([resource_name, :verify_authy_installation], :class => 'authy-form', :method => :post) do
          capture(&block)
        end
      end
    end
  end
end

