module BooleanDateTime
  def boolean_date_time_field(column_name, as:)
    define_method "#{as}=" do |value|
      value = ActiveRecord::Type::Boolean.new.type_cast_from_user(value)
      self[column_name] = value ? DateTime.now.utc : nil
    end

    define_method as do
      !self[column_name].nil?
    end

    alias_method "#{as}?", as
  end
end
