#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe 'dns_rlookup' do
  it 'should return list of results from a reverse lookup' do
    results = subject.execute('8.8.4.4')
    expect(results).to be_a Array
    expect(results).to all(be_a(String))
  end
end
