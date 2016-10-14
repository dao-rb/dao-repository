describe Dao::Repository::Scope do
  describe '#method_missing' do
    let(:gateway) { spy(serializable_relations: []) }
    let(:scope) { described_class.new(gateway) }
    let(:method_name) { :foo }

    it 'should add method call with specified argument' do
      expect(gateway).to receive(:chain).with(anything, method_name, [1])
      expect(gateway).not_to receive(:add_relations)

      scope.send(method_name, 1)
    end

    it 'should add with' do
      expect(gateway).to receive(:chain).with(anything, method_name, [1])
      expect(gateway).to receive(:add_relations).with(anything, [2])

      scope.send(method_name, 1, with: 2)
    end

    context 'when arguments was not specified' do
      it 'should add with and call without arguments' do
        expect(gateway).to receive(:chain).with(anything, method_name, [])
        expect(gateway).to receive(:add_relations).with(anything, [2])

        scope.send(method_name, with: 2)
      end
    end

    context 'when argument is a empty hash' do
      it 'should add with and call without arguments' do
        expect(gateway).to receive(:chain).with(anything, method_name, [{}])
        expect(gateway).not_to receive(:add_relations)

        scope.send(method_name, {})
      end
    end

    context 'when options have additional values' do
      it 'should add with and call with other options' do
        expect(gateway).to receive(:chain).with(anything, method_name, [{ foo: :bar }])
        expect(gateway).to receive(:add_relations).with(anything, [{bar: :foo}])

        scope.send(method_name, foo: :bar, with: { bar: :foo })
      end
    end

    context 'when have argument and options have additional values' do
      it 'should add with and call with other options' do
        expect(gateway).to receive(:chain).with(anything, method_name, [1, { foo: :bar }])
        expect(gateway).to receive(:add_relations).with(anything, [{bar: :foo}])

        scope.send(method_name, 1, foo: :bar, with: { bar: :foo })
      end
    end
  end
end
