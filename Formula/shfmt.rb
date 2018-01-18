class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.2.0.tar.gz"
  sha256 "f556fbd368e6bae0a5baed74138db8bca5fc0e96482ea5231c329a8aecb64b44"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45bd5112c69c48f5b19bce1d7c92aeb8cbef3d03716b3b4ca9a5d06926d129fb" => :high_sierra
    sha256 "181aa0535d88e80803e7a77fd67a8ba4d736fcdafcb1f971db7e3ae8b8fcb9fe" => :sierra
    sha256 "680f36f0009d752c1543b702f7c5f677dde7b4fab1595b4256de51e4d30a6939" => :el_capitan
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
