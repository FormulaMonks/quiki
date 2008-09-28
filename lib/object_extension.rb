class Object
  def is_a_with_multiple?(*classes)
    classes.each do |klass|
      return true if is_a_without_multiple?(klass)
    end
    return false
  end
  alias_method_chain :is_a?, :multiple
end