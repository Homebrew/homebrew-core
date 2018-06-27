class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/2.0.1.tar.gz"
  sha256 "5ef118f6d75fe84b5c24b2f9250edbbe4a5c14f1a70a978eabd80e4f91047497"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ee9ef043633dad2643ea979430d101e944ef9228f8667004a2084572cca78b4" => :high_sierra
    sha256 "124ead65092c9b8a43d1d907660f77bf6e1cc482219e34cd46d931681b984eb2" => :sierra
    sha256 "cf358cac95f68ad36a368be6cae4d7a0bf164879c23c57c69adac025f197de66" => :el_capitan
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
