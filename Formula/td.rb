class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.4.2.tar.gz"
  sha256 "e85468dad3bf78c3fc32fc2ab53ef2d6bc28c3f9297410917af382a6d795574b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43a810119f258b36c6d925cc9e28bce5f20dc660c2ac0292c1ebd577213e8216"
    sha256 cellar: :any_skip_relocation, big_sur:       "80ef002d9503b2c3fbe75ff5c5a98d501ac173a901cb5bc6567376631c662f19"
    sha256 cellar: :any_skip_relocation, catalina:      "a76305e7189f1331d8c8a31ef32d1d01b9898fd7687dbe6ebe637f4cecc3060d"
    sha256 cellar: :any_skip_relocation, mojave:        "424e207b26bc77d0c515dbdd771c159549e932f6bbc102eb3a3a3b3dcdecb91c"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/Swatto/td").install buildpath.children
    cd "src/github.com/Swatto/td" do
      system "go", "install"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/".todos").write "[]\n"
    system "#{bin}/td", "a", "todo of test"
    todos = (testpath/".todos").read
    assert_match "todo of test", todos
    assert_match "pending", todos
  end
end
