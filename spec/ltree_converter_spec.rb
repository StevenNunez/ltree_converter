require_relative '../ltree_converter'
describe LtreeConverter do
  describe "#to_breadcrumbs" do
    it "converts a single ltree to breadcrubms" do
      ltree = LtreeConverter.new("Intro_to_Ruby.Strings.What_are_strings--63")
      expect(ltree.to_breadcrumbs(" >> ")).to eq("Intro to Ruby >> Strings >> What are strings?")
    end

    it "handles multiple escaped characters" do
      ltree = LtreeConverter.new("Intro_to_Ruby.Strings.What_are_strings--63--63")
      expect(ltree.to_breadcrumbs(" >> ")).to eq("Intro to Ruby >> Strings >> What are strings??")
    end
  end

  describe "to_ltree" do
    it "converts a single ltree to breadcrubms" do
      ltree = LtreeConverter.new("Intro to Ruby >> Strings >> What are strings?")
      expect(ltree.to_ltree(" >> ")).to eq("Intro_to_Ruby.Strings.What_are_strings--63")
    end
  end

  describe "::build_hierachy" do
    it "builds nested structure based on Ltree names" do
      hierarchy = LtreeConverter.build_hierachy([
        "Intro_to_Ruby.Strings.What_are_strings--63", 
        "Intro_to_Ruby.Arrays.What_are_arrays--63.Arrays_in_the_wild",
        "Intro_to_Ruby.Arrays.What_are_arrays--63.When_to_use_arrays"
      ])
      expect(hierarchy).to eq({
        "Intro to Ruby" => {
          "Strings" => {
            "What are strings?" => {terminate: true}
          },
          "Arrays" => {
            "What are arrays?" => {
              "Arrays in the wild" => {terminate: true},
              "When to use arrays" => {terminate: true},
            }
          }
        },
      })
    end
  end
end

# order
