class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/1.15.0.tar.gz"
  sha256 "f8eb713178720008744a68bcb5c9563cbe4674a579d5d46018797bc917ccca26"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa3095e1fcb4f8eeabd575089b7b28915164f10e0c595966e6ad5a452a5407e0" => :high_sierra
    sha256 "4e9da4dd26496cd6de7852afa0c2c9ff4d951adf1ba384940ac06d924b65ee8a" => :sierra
    sha256 "da5acccd05b210a6cea087ff1dd9b7d7f337693070c3898f891516f11b5aeb4d" => :el_capitan
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
