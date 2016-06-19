describe Dao::Repository::Base do
  let(:transformer) { Dao::Repository::ScopeTransformer }
  let(:gateway) { Dao::Repository::Gateway }
  let(:source) { double('Source') }
  let(:entity) { double('Entity') }

  let(:repository) { Class.new(described_class) }

  before { repository.entity(entity) }
  before { repository.gateway(gateway, source, transformer) }

  describe '.gateway' do
    context 'setter' do
      subject { repository.gateway }

      it { is_expected.to be_a gateway }
      its(:source) { is_expected.to eq source }

      describe 'transformer' do
        subject { repository.gateway.transformer }

        it { is_expected.to be_a transformer }
        its(:entity) { is_expected.to eq entity}
      end
    end

    context 'getter' do
      context 'with 1 argument' do
        subject { repository.gateway(1) }

        it { is_expected.to be_a gateway }
      end

      context 'with 2 arguments' do
        subject { repository.gateway(1, 2) }

        it { is_expected.to be_a gateway }
      end
    end
  end

  describe '.find' do
    it 'should call scope' do
      expect_any_instance_of(Dao::Repository::Scope).to receive(:find).with(1, {}).and_return(spy)

      repository.find(1)
    end

    it 'should call scope with relations' do
      expect_any_instance_of(Dao::Repository::Scope).to receive(:find).with(1, with: :relation).and_return(spy)

      repository.find(1, with: :relation)
    end
  end
end
