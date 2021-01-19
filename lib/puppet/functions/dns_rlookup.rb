# Retrieves results from DNS reverse lookup and returns it as an array.
# Each record in the array will be a hostname.
# An optional lambda can be given to return a default value in case the
# lookup fails. The lambda will only be called if the lookup failed.
Puppet::Functions.create_function(:dns_rlookup) do
  dispatch :dns_rlookup do
    param 'String', :record
  end

  dispatch :dns_rlookup_with_default do
    param 'String', :record
    block_param
  end

  def dns_rlookup(address)
    addr = IPAddr.new(address)
    Resolv::DNS.new.getresources(
      addr.reverse(), Resolv::DNS::Resource::IN::PTR
    ).collect do |res|
      res.name.to_s
    end
  end

  def dns_rlookup_with_default(address)
    ret = dns_rlookup(address)
    if ret.empty?
      yield
    else
      ret
    end
  rescue Resolv::ResolvError
    yield
  end
end
