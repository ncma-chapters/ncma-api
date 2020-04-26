RSpec.shared_examples_for 'it requires user to be in EventManagers group' do |method_name|
  let (:factory) { described_class.to_s.remove('Policy').underscore.to_sym }

  it 'returns false when user is nil' do
    subject = described_class.new nil, build(factory)
    expect(subject.send(method_name)).to eq(false)
  end

  it 'returns false when user is not in EventManagers group' do
    user = double
    subject = described_class.new user, build(factory)

    expect(user).to receive(:in_group).with(
      'EventManagers'
    ).and_return(
      false
    )

    expect(subject.send(method_name)).to eq(false)
  end

  it 'returns true when user is in EventManagers group' do
    user = double
    subject = described_class.new user, build(factory)

    expect(user).to receive(:in_group).with(
      'EventManagers'
    ).and_return(
      true
    )

    expect(subject.send(method_name)).to eq(true)
  end
end
