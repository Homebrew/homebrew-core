class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/1.4.0.tar.gz"
  sha256 "b8080a73b274c201bc1fadaf5b83e5fab26b38838f4c82b49f1ae5dadaa94c20"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4a2ee497032f6ca01acbbd66ef0fbc27709fd463d0d33a583b1c6de57a18edf" => :sierra
    sha256 "867b8f9f687f76225eebbb3b183206178fb1321f87e14e6a101bdf40d2f9fbce" => :el_capitan
    sha256 "38428b68601f84a7cf0360bea09b17d891bd5bb2a5d6fbc6bce420011de698d2" => :yosemite
    sha256 "f73a1a4e82115217791c73e95938f474f906f5215164abd71d71c9304674895e" => :mavericks
    sha256 "c3e12ecfa1b4c9530f2f27c6707cf8e493377ca6132170814476d715564c536f" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
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
