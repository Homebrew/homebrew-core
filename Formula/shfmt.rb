class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v1.2.0.tar.gz"
  sha256 "3d2973f1adf99fcf65baae3c85697313a782dbedc2600fedb28687541a20ed43"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa7d4d0e444e9003f7df157fb4c61144abb978e592186a26a16f0543d822202d" => :sierra
    sha256 "83f2143f43b0361f95ee2f6828cfd612f81698074e468a0214ab0d3a5fe96f89" => :el_capitan
    sha256 "f48d1c2fc94ee6008a0554ce9449fc76dd68b5727a924debd9a49c59f6e6c52c" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mvdan/sh").install Dir.glob(buildpath/"*")
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "github.com/mvdan/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
