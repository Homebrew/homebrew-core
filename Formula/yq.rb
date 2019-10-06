class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/2.4.0.tar.gz"
  sha256 "5277293b3bcd7c891d8c20c029637ca5064409696b77937a1cba1bfc07164163"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebdc4caf081175e62de1abb29bbaa25f82db759ed553d4db49f9144878c2fde6" => :catalina
    sha256 "04f9e504ff627ee5c24a2051122c68bbb2cabf66d6ea2be4c6d161613e38d2c0" => :mojave
    sha256 "691172310ea3a78373640dcb21d2d9f8615d337f7314e78627fbda47dd59f47c" => :high_sierra
    sha256 "8ea51e4fd94aada42606ed05feed0475d87d50d301a2144860d8c85f4220c2d1" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

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
