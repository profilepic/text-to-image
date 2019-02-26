#############################################
# Address Book Contract


Person = Struct.new(
  first_name: '',
  last_name:  '',
  street:     '',
  city:       '',
  state:      ''
)

def setup
  @addresses = Mapping.of( Address => Person )
end


def put( address, first_name, last_name, street, city, state )
  assert msg.sender == address

  rec =  @addresses[ address ]
  if rec == Person.zero    ## insert entry if new
    rec.first_name = first_name
    rec.last_name  = last_name
    rec.street     = street
    rec.city       = city
    rec.state      = state
  else  ## update entry if found / exists (already)
    rec.first_name = first_name
    rec.last_name = last_name
    rec.street = street
    rec.city = city
    rec.state = state
  end
end

def delete( address )
    assert msg.sender == address

    assert @addresses[ address ] == Person.zero, "Record does not exist"
    @addresses.delete( address )
end
