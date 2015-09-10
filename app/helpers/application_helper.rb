module ApplicationHelper
  def resource_name
    @model_class.name.downcase.to_sym
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[resource_name]
  end
end
