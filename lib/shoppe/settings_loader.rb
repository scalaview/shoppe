module Shoppe
  class SettingsLoader

    def initialize(app)
      @app = app
      @shoppe = Shoppe
    end

    def call(env)
      @shoppe.reset_settings
      @app.call(env)
    ensure
      if Shoppe.to_s == 'Shoppe'
        Shoppe.reset_settings
      else
        @shoppe.reset_settings
      end
    end

  end
end
