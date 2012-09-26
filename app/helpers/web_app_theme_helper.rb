module WebAppThemeHelper

  def model_type
    controller.class.to_s.gsub(/Controller/, '').singularize
  end

  def model_klass
    model_type.constantize
  end

  # Returns nil if partial does not exist
  def main_navigation_partial
    partial_path = "shared/"
    partial_name = "main_navigation"
    path_exists?("app/views/#{partial_path}_#{partial_name}.html.*") ? "#{partial_path}#{partial_name}" : nil
  end

  # Returns nil if partial does not exist
  def navigation_partial
    # Aufgrund Controller ermitteln...
    controller.class.ancestors.grep(Class).each do |klass|
      basepath = klass.to_s.gsub(/Controller/, '').underscore
      nr_of_levels = basepath.scan(/\//).size + 1
      partial_path = basepath
      nr_of_levels.times do |i|
        partial_name = "navigation"
        return "#{partial_path}/#{partial_name}" if path_exists?("app/views/#{partial_path}/_#{partial_name}.html.*")
        partial_name = "navigation_#{partial_path.gsub(/\//, "_")}"
        return "shared/#{partial_name}" if path_exists?("app/views/shared/_#{partial_name}.html.*")
        index = partial_path.rindex(/\//)
        a = partial_path.split('/')
        a.pop
        partial_path = ""
        not_first = false
        a.each do |s|
          if not_first
            partial_path += "/"
          end
          partial_path += s
        end
      end
    end
    nil
  end

  def sidebar_partials
    partials = Array.new
    controller.class.ancestors.grep(Class).each do |klass|
      basepath = klass.to_s.gsub(/Controller/, '').underscore
      nr_of_levels = basepath.scan(/\//).size + 1
      partial_path = basepath
      nr_of_levels.times do |i|
        partial_name = "sidebar"
        partials << "#{partial_path}/#{partial_name}" if path_exists?("app/views/#{partial_path}/_#{partial_name}.html.*")
        partial_name = "sidebar_#{partial_path.gsub(/\//, "_")}"
        partials << "shared/#{partial_name}" if path_exists?("app/views/shared/_#{partial_name}.html.*")
        index = partial_path.rindex(/\//)
        a = partial_path.split('/')
        a.pop
        partial_path = ""
        not_first = false
        a.each do |s|
          if not_first
            partial_path += "/"
          end
          partial_path += s
        end
      end
    end
    partials.reverse
  end

  def path_exists?(path_string)
    Dir.glob(Rails.root.join(path_string)).each do |path|
      return true if File.exists?(path)
    end
    false
  end

  def t_attr_desc(type = nil, string_or_symbol)
    type_string = type.nil? ? model_type : type.to_s
    t(type_string.underscore.gsub(/^/, 'activerecord.descriptions.').gsub(/$/, ".#{string_or_symbol}"), :default => "")
  end

  def t_klass_desc(type = nil)
    type_string = type.nil? ? model_type : type.to_s
    t(type_string.underscore.gsub(/^/, 'activerecord.descriptions.').gsub(/$/, ".model"), :default => "")
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
