class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v1.3.0.tar.gz"
  sha256 "e1c2ad59e18e9a0af4bfb3f75c9b1c783877f2bcf839784b5bf488bb36b80bf7"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2359f56d08f1ce7cf2fe6c060c3150b19d6ee8842445b42462d3a169fddfbeec" => :sierra
    sha256 "fe8968cd0a55f7b7232c01b4e3845e66a34e35d33dfe8e47c83b2da77c5123d3" => :el_capitan
    sha256 "e499013b43e69be633afec94c50c347924ceac91170516762f7873cbf98a83e1" => :yosemite
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
