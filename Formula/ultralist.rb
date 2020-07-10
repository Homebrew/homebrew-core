class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/1.0.tar.gz"
  sha256 "c0c5ec731fdd5556de8996a29e13f19c90f25bbfc7c19a00abd2edbfd5068e28"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c1c484137baf1be16e5582285b8b66bc4e29b324609a577740af3c969b0a21e" => :catalina
    sha256 "a31c67179fa04dbd69aa933012cc966963f8f70409af0f6c52526c092364ff58" => :mojave
    sha256 "ce141acbf7f825124d9b129787f5add4e3653ac21119efb1188624b586fd17fe" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
