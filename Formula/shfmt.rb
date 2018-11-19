class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.6.1.tar.gz"
  sha256 "faa1a40964744508b737a2c536f01e74e96162f30ac12f967656fa272d292c53"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72b464f5c78a49c3f1f707dbc79ca6b0e476d02a247b9426e3f85704ed545df5" => :mojave
    sha256 "cdfcf94dca01736d24f8c55b99f7feb8ff35a61017b99f708bec24a338569725" => :high_sierra
    sha256 "81a3c1e27f878b79c1d8cb2bee5457fa648323a905f12e8c85b19e8466d9c772" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "mvdan.cc/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
