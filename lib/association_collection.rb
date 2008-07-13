module CitrusByte
  module Associations
    module HasManyExtensions
      # works just like << except returns the added records instead of self, so
      # it's not chainable but allows you to do something like:
      #   @jim = Book.authors.add Author.new(:name => 'jim')
      # (often saving a whole line of code!)
      def add(*records)
        self.<<(*records)
        unarray_if_lonely(records)
      end
      
      # works just like add except raises an exception on error
      def add!(*records)
        raise ActiveRecord::RecordInvalid.new(*records) unless self.<<(*records)
        unarray_if_lonely(records)
      end
      
      # if the given object is an array of size 1 then it returns the only
      # element itself (w/ no array), otherwise it just gives back object
      def unarray_if_lonely(object)
        (object.is_a?(Array) && object.length == 1) ? object.first : object
      end
    end
  end
end

module ActiveRecord
  module Associations
    class AssociationCollection < AssociationProxy #:nodoc:
      include(CitrusByte::Associations::HasManyExtensions)
    end
  end
end
