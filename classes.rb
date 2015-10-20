# Building class
class Building
  attr_reader :address, :apartments

  def initialize(n_address)
    @address = n_address
    @apartments = []
  end

  def add_apartments(apt)
    @apartments << apt
  end

  def remove_apartment_by_number(num)
    to_remove = @apartments.select {|a| a.number == num}

    if (to_remove == [])
      raise "apartment not found"
    elsif (to_remove[0].tenants.length != 0)
      raise "apartment not empty"
    else
      @apartments.reject! {|a| a.number == num}
    end

    return @apartments
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

# Apartment class
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

# Tenant class
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

# test code
t1 = Tenant.new("A", 25, 780)
t2 = Tenant.new("B", 30, 700)
t3 = Tenant.new("C", 25, 600)
t4 = Tenant.new("D", 25, 650)
tb = Tenant.new("E", 25, 300)

a1 = Apartment.new(1, 1000, 500, 2, 1)
a2 = Apartment.new(2, 2000, 700, 1, 1)

a1.add_tenant(t1)
a1.add_tenant(t2)

# Error because apartment is full
a1.add_tenant(t3)
# error because tb has bad credit
a2.add_tenant(tb)

b1 = Building.new("1 first st")
b1.add_apartments(a1)
b1.add_apartments(a2)

#Error because apartment is occupied
b1.remove_apartment_by_number(1)
