class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/2.0.0.tar.gz"
  sha256 "4a433a8881c6edc43be871f01e493b179e85404c26c91e4980a0010cae407815"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f7062d0910292365f2073045189f5f683656c782d1d5685293f559787413719" => :high_sierra
    sha256 "8e826a4f13b48652360d437a05166fb74157bcce8382f32e78315322d464b132" => :sierra
    sha256 "b691e2a07fe7e188de67bdf4a6e76a52a4f1661bfd9df3af85b9dfbe5adea9d8" => :el_capitan
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
