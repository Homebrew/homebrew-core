class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.2.1.tar.gz"
  sha256 "b327873c13a3d27b5b8ca132997c55da03851b5872cc187aa1d7a10c3886312c"
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
