SimpleSerializer
=================

This is just realy simple serializer for ActiveRecord-objects.

Example
=======

```ruby

class User
  belongs_to :role, polymorphic: true
  
  attr_accessible :full_name

class Company
  has_one :user, as: :role
  
  attr_accessible :employees_count
end

class Employee
  has_one :user, as: :role
  attr_accessible :companies_count
end


class RoleSerializer < SimpleSerializer::Base
  def full_name
    model.user.full_name
  end
end

class CompanySerializer < RoleSerializer
  attribute :full_name
  attribute :employees_count, as: :count
end


class EmployeeSerializer < RoleSerializer
  attribute :full_name
  attribute :companies_count, as: :count
end


CompanySerializer.serialize(Company.all).to_json # => [ { :full_name => "Some Company", :count => 2 } ]
EmployeeSerializer.serialize(Emplpoyee.all).to_json # => [ { :full_name => "Some Employee", :count => 1 } ]
