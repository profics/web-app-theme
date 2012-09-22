module WebAppThemeHelper

  def model_type
    controller.class.to_s.gsub(/Controller/, '').singularize
  end

  def model_klass
    model_type.constantize
  end

  # Returns nil if parcel does not exist
  def main_navigation_parcel
    parcel_path = "shared/"
    parcel_name = "main_navigation"
    path_exists?("app/views/#{parcel_path}_#{parcel_name}.html.*") ? "#{parcel_path}#{parcel_name}" : nil
  end

  def path_exists?(path_string)
    Dir.glob(Rails.root.join(path_string)).each do |path|
      return true if File.exists?(path)
    end
    false
  end

  # Returns nil if parcel does not exist
  def navigation_parcel
    # Aufgrund Controller ermitteln...
    controller.class.ancestors.grep(Class).each do |klass|
      basepath = klass.to_s.gsub(/Controller/, '').underscore
      nr_of_levels = basepath.scan(/\//).size + 1
      parcel_path = basepath
      nr_of_levels.times do |i|
        parcel_name = "navigation"
        return "#{parcel_path}/#{parcel_name}" if path_exists?("app/views/#{parcel_path}/_#{parcel_name}.html.*")
        parcel_name = "navigation_#{parcel_path.gsub(/\//, "_")}"
        return "shared/#{parcel_name}" if path_exists?("app/views/shared/_#{parcel_name}.html.*")
        index = parcel_path.rindex(/\//)
        a = parcel_path.split('/')
        a.pop
        parcel_path = ""
        not_first = false
        a.each do |s|
          if not_first
            parcel_path += "/"
          end
          parcel_path += s
        end
      end
    end
    nil
  end

  def t_attr(type = nil, string_or_symbol)
    type_string = type.nil? ? model_type : type.to_s
    t(type_string.underscore.gsub(/^/, 'activerecord.attributes.').gsub(/$/, ".#{string_or_symbol}"), :default => t("activerecord.labels.#{string_or_symbol}", :default => string_or_symbol.to_s.humanize))
  end
  
  def t_klass(type = nil, count = 1)
    type_string = type.nil? ? model_type : type.to_s
    t(type_string.underscore.gsub(/^/, 'activerecord.models.'), :count => count, :default => type_string.humanize)
  end
  
  def t_klasses(type = nil)
    t_klass(type, 2)
  end
  
  def t_wat(string_or_symbol)
    opts = {
      :scope => 'web-app-theme', 
      :default => string_or_symbol.to_s.titleize
    }
    t(string_or_symbol, opts)
  end
  
  def t_nav1(string_or_symbol)
    opts = {
      :scope => ["web-app-theme.nav", string_or_symbol.to_s].join("."),
      :default => string_or_symbol.to_s.titleize
    }
    t(:label, opts)
  end
  
  def t_nav2(first_level, string_or_symbol)
    opts = {
      :scope => ["web-app-theme.nav", first_level.to_s].join("."),
      :default => string_or_symbol.to_s.titleize
    }
    t(string_or_symbol, opts)
  end

end
