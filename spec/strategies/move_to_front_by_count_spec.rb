require_relative '../../lib/counting_list'
require_relative '../../lib/strategies/move_to_front_by_count'

RSpec.describe Strategies::MoveToFrontByCount do
  subject(:list) do
    CountingList.new(['item1', 'item2', 'item3', 'item3', 'item4']).with_optimizer do |list, current|
      described_class.optimize(list, current)
    end
  end

  it 'can optimize a list with move to front' do
    list.retrieve('item3')
    current = list.head
    # while current.next
    #   puts current.value
    #   current = current.next
    # end
    # puts current.value
    expect(list.to_a).to eql(["item3", "item1", "item2", "item3", "item4"])
    list.retrieve('item3')
    list.retrieve('item3')
    list.retrieve('item3')
    list.retrieve('item3')
    # expect(list.to_a).to eql(["item3", "item4", "item1", "item2", "item3"])
    puts list.head.count
    list.retrieve('item3')
    puts list.head.count
    list.retrieve('item4')
    expect(list.to_a).to eql(["item3", "item4", "item1", "item2", "item3"])
    # list.retrieve('item4')
    list.retrieve('item40')
    puts list.to_a

  end

  it 'has a reduced hop count with move to front' do
    expect {
      list.retrieve('item3')
      list.retrieve('item3')
    }.to change { list.hop_count }.by(2)
  end

  context 'stress test' do
    # let(:values) { File.read('spec/data/goethe_wette.txt').split(/\W+/) }
    let(:values) {
      ["item3", "item5", "item4", "item2"]
    }

    subject(:big_list) do
      CountingList.new(values).with_optimizer do |list, current|
        described_class.optimize(list, current)
      end
    end

    it 'it is optimized after a lot of accesses' do
      puts "---"
      40.times do
        puts "retrieve"
        value = values.sample
        puts "- #{value}"
        big_list.retrieve(value)
      end
      def print_list
      end

      expect {
        1000.times do
          big_list.retrieve(values.sample) rescue print_list
        end
      }.to change { big_list.hop_count }.by_at_most(100_000)

      puts big_list.hop_count
      puts big_list.to_a
    end
  end
end
