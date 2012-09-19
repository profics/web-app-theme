module WebAppThemeHelper

  def model_klass
    controller.class.to_s.gsub(/Controller/, '').singularize.constantize
  end
  
  def t_attr(type_string = nil, symbol)
    type_string ||= controller.model_type
    t(type_string.underscore.gsub(/^/, 'activerecord.attributes.').gsub(/$/, ".#{symbol}"), :default => symbol.to_s.humanize)
  end
  
  def t_klass(type_string = nil, count = 1)
    type_string ||= controller.model_type
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
