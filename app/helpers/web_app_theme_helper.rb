module WebAppThemeHelper

  def model_type
    controller.class.to_s.gsub(/Controller/, '').singularize
  end

  def model_klass
    model_type.constantize
  end

  def t_attr(type_string = nil, string_or_symbol)
    type_string ||= model_type
    t(type_string.underscore.gsub(/^/, 'activerecord.attributes.').gsub(/$/, ".#{string_or_symbol}"), :default => t("activerecord.labels.#{string_or_symbol}", :default => string_or_symbol.to_s.humanize))
  end
  
  def t_klass(type_string = nil, count = 1)
    type_string ||= model_type
    t(type_string.underscore.gsub(/^/, 'activerecord.models.'), :count => count, :default => type_string.humanize)
  end
  
  def t_klasses(type_string = nil)
    t_klass(type_string, 2)
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
