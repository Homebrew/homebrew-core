class Vert < Formula
  desc "Command-line version testing"
  homepage "https://github.com/Masterminds/vert"
  url "https://github.com/Masterminds/vert/archive/v0.1.0.tar.gz"
  sha256 "96e22de4c03c0a5ae1afb26c717f211c85dd74c8b7a9605ff525c87e66d19007"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2fbb031b72d6b4524dc31add5536acef1fdb913c5db28240bd4352c107da638" => :mojave
    sha256 "b7c63c671335e19afca83f08091a987c35576eb4cb94f1d7b00490d1448f3e77" => :high_sierra
    sha256 "e189a592a062ef9e2cc19506f99272ffc9f97f3e529a54eddd7287f0c9574935" => :sierra
    sha256 "534043c69cbd56a22d656ba873e180e628b3a0ace433d8f020b886212afa050e" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Masterminds/vert").install buildpath.children
    cd "src/github.com/Masterminds/vert" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "vert"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/vert 1.2.3 1.2.3 1.2.4 1.2.5", 2)
    assert_match "1.2.3", output
  end
end
