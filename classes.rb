class Building
  attr_reader :address

  def initialize(n_address)
    @address = n_address
    @apartments = []
  end

  def add_apartments(apt)
    @apartments << apt
  end

  def remove_apartment_by_number(num)
    remaining = @apartments.reject {|apt| apt.number == num}

    if (@apartments.length == remaining.length) || (apt.tenants.length != 0)
      raise "apartment not found or apartment is occupied"
    else
      @apartments = remaining
    end
    # allow to override second condition
  end

  def total_sq_footage
    @apartments.map {|apt| apt.sqft}.reduce(:+)
  end

  def total_monthly_revenue
    @apartments.map {|apt| apt.rent}.reduce(:+)
  end

  def tenant_list
    result = []
    @apartments
      .map {|apt| apt.tenants}
      .each {|tenant_l| result.concat(tenant_l)}
    return result
  end

  def apartments_sorted_by_credit
    @apartments.sort_by {|apt| apt.average_credit_score}
  end

end

class Apartment
  attr_reader :number, :sqft, :bedrooms, :bathrooms, :tenants
  attr_accessor :rent
  def initialize(n_number, n_rent, n_sqft, n_bedrooms, n_bathrooms)
    @number = n_number
    @rent = n_rent
    @sqft = n_sqft
    @bedrooms = n_bedrooms
    @bathrooms = n_bathrooms
    @tenants = []
  end

  def add_tenant(n_tenant)
    if (n_tenant.credit_rating == "bad") || (@tenants.length + 1 > @bedrooms)
      raise "bad credit rating or no rooms available"
    else
      @tenants << (n_tenant)
    end
  end

  def remove_tenant(name)
    remaining = @tenants.reject {|tenant| tenant.name == name}

    if (@tenants.length == remaining.length)
      raise "tenant not found"
    else
      @tenants = remaining
    end
  end

  def average_credit_score
    @tenants.map {|tenant| tenant.credit_score}.reduce(:+)/@tenants.length
  end

  def credit_rating
    rating = "bad"
    rating = "mediocre" if @average_credit_score >= 560
    rating = "good" if @average_credit_score >= 660
    rating = "great" if @average_credit_score >= 725
    rating = "excellent" if @average_credit_score >= 760
    return rating
  end
end

class Tenant
  attr_accessor :credit_score
  attr_reader :name, :age

  def initialize(n_name, n_age, n_credit_score)
    @name = n_name
    @age = n_age
    @credit_score = n_credit_score
  end

  def credit_rating
    rating = "bad"
    rating = "mediocre" if @credit_score >= 560
    rating = "good" if @credit_score >= 660
    rating = "great" if @credit_score >= 725
    rating = "excellent" if @credit_score >= 760
    return rating
  end
end
