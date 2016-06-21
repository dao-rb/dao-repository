require 'dao/gateway'

describe Dao::Repository::Base do
  let(:transformer) { Dao::Gateway::ScopeTransformer }
  let(:gateway) { Dao::Gateway::Base }
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

  describe '.find_by_id' do
    it 'should call scope' do
      expect_any_instance_of(Dao::Repository::Scope).to receive(:find_by_id).with(1).and_return(spy)

      repository.find_by_id(1)
    end
  end

  describe '.last' do
    it 'should call scope' do
      expect_any_instance_of(Dao::Repository::Scope).to receive(:last).with({}).and_return(spy)

      repository.last
    end

    it 'should call scope with relations' do
      expect_any_instance_of(Dao::Repository::Scope).to receive(:last).with(with: :relation).and_return(spy)

      repository.last(with: :relation)
    end
  end

  describe '.count' do
    it 'should call scope' do
      expect_any_instance_of(Dao::Repository::Scope).to receive(:count).and_return(spy)

      repository.count
    end
  end

  describe '.delete_by_id' do
    it 'should call gateway' do
      expect_any_instance_of(gateway).to receive(:delete).with(1)

      repository.delete_by_id(1)
    end
  end

  describe '.delete' do
    it 'should call gateway' do
      expect_any_instance_of(gateway).to receive(:delete).with(1)

      repository.delete(double(id: 1))
    end

    it 'should not call gateway' do
      expect_any_instance_of(gateway).to_not receive(:delete)

      repository.delete(nil)
    end
  end

  describe '.build' do
    let(:record) { double }

    it 'should call gateway' do
      expect_any_instance_of(gateway).to receive(:map).with(record, {})

      repository.build(record)
    end
  end

  describe '.save' do
    let(:record) { double }

    it 'should call gateway with default attributes' do
      expect_any_instance_of(gateway).to receive(:save!).with(record, {})

      repository.save(record)
    end

    it 'should call gateway with defined attributes' do
      expect_any_instance_of(gateway).to receive(:save!).with(record, foo: :bar)

      repository.save(record, foo: :bar)
    end
  end
end
