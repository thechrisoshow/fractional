module DeprecatedFractionalMethods

  def to_f(value)
    warn("Fractional.to_f will be removed in v1.1.")
    string_to_fraction(value).to_f
  end

  def to_s(value, options={})
    warn("Fractional.to_s will be removed in v1.1\nUse Fractional.new(value).to_s instead.")
    new(float_to_fraction(value)).to_s(options)
  end

  def fraction?(value)
    warn("Fractional.fraction? will be removed in v1.1\nUse Fractional.string_is_fraction? instead.")
    string_is_fraction?(value)
  end

  def mixed_fraction?(value)
    warn("Fractional.mixed_fraction? will be removed in v1.1\nUse Fractional.string_is_mixed_fraction? instead.")
    string_is_mixed_fraction?(value)
  end

  def single_fraction?(value)
    warn("Fractional.single_fraction? will be removed in v1.1\nUse Fractional.string_is_single_fraction? instead.")
    string_is_single_fraction?(value)
  end

  private
  def warn(message)
    $stderr.puts "\n*** Fractional deprecation warning: #{message}\n\n"
  end

end