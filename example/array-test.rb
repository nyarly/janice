Janice.explain do
  setup("number one"){ 1 }

  setup("empty array"){ Array.new }
  exercise "add an item" do |array, registry|
    array << registry["number one"]
  end
  verify do
    adhoc{|arr| arr.length == 1}
    eql("red herring")

    also{|arr| arr.length}.to do
      eql(1)
    end
  end

  from "empty array"
  exercise "add two items" do |array|
    array += [3, 4]
  end
  verify do
    also{|arr| arr.length}.to do
      eql(2)
    end
  end
end
