require 'spec_helper'

describe InstitutesMaster do

  before { @institute = InstitutesMaster.new(name: "Example Institute") }

  subject { @institute }

  it { should respond_to(:name) } 
end
