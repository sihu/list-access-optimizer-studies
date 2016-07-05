module Strategies
  class MoveToFrontByCount
    def self.optimize(list, last_accessed_item)
      last_accessed_item.count += 1
      return if last_accessed_item == list.head

      last_accessed_item_is_first = last_accessed_item.count >= list.head.count
      current = list.head
      predecessor = nil
      future_predecessor = nil

      # while predecessor.nil?
      while current.next != last_accessed_item

        if !future_predecessor && last_accessed_item.count >= current.next.count
          puts "found"
          future_predecessor = current
        end
        current = current.next
      end
      predecessor = current

      # future_predecessor = current unless future_predecessor

      if predecessor != future_predecessor

        predecessor.next = last_accessed_item.next
      end

      if last_accessed_item_is_first
        last_accessed_item.next = list.head
        list.head = last_accessed_item
      else
        puts list.to_a if future_predecessor.nil? 
        last_accessed_item.next = future_predecessor.next
        future_predecessor.next = last_accessed_item
      end
    end
  end
end
