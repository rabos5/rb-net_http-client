require_relative '../spec_helper'

describe NetHTTP::VERSION do
  it 'should have a valid version' do
    expect(NetHTTP::VERSION.nil?).to eq(false)
    expect(NetHTTP::VERSION.empty?).to eq(false)
    expect(NetHTTP::VERSION.class).to eq(String)
    expect(NetHTTP::VERSION.frozen?).to eq(true)
  end
end
