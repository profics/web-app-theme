module WebAppTheme
    class AssetsGenerator < Rails::Generators::Base
      desc "Copy the --theme stylesheets to your rails application assets path, so you can customize them"
      source_root File.expand_path('../../../../../app/', __FILE__)
      class_option :theme,        :type => :string,   :default => :default,   :desc => 'Specify the layout theme to be copied'

      def copy_stylesheets
        copy_file "assets/stylesheets/web-app-theme/base.css"                , "app/assets/stylesheets/web-app-theme/base.css"
        directory "assets/stylesheets/web-app-theme/themes/#{options.theme}" , "app/assets/stylesheets/web-app-theme/themes/#{options.theme}"
      end

      def copy_images
        directory "assets/images/web-app-theme/themes/#{options.theme}"      , "app/assets/images/web-app-theme/themes/#{options.theme}"
      end

      def copy_helper
        copy_file "helpers/web_app_theme_helper.rb", "app/helpers/web_app_theme_helper.rb"
      end

    end
  end
