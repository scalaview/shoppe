module Shoppe
  class SettingsLoader

    def initialize(app)
      @app = app
    end

    def call(env)
      ModuleShoppe.reset_settings
      @app.call(env)
    ensure
      ModuleShoppe.reset_settings
    end

  end
end
