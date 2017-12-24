class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/1.14.0.tar.gz"
  sha256 "cf61f84033ed8e1cb146798bfcedfabba5fa8852331a90122eafaae0f31c4b70"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a77152a4f6af9543e0f021297492a80ad790cc33c28a102052cef21941b2755" => :high_sierra
    sha256 "c664274a8f439a63e0de3b74ba918df70412f8effc71d0ee5b998e9ebd88b716" => :sierra
    sha256 "66137bf0dbc35984d6492e3e29f5aa7f0c5d04889f1fa7880aad93067d3692b5" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
