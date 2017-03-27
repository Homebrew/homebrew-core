class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v1.2.0.tar.gz"
  sha256 "3d2973f1adf99fcf65baae3c85697313a782dbedc2600fedb28687541a20ed43"
  head "https://github.com/mvdan/sh.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mvdan").mkpath
    (buildpath/"src/github.com/mvdan/sh").install buildpath/"cmd"
    (buildpath/"src/github.com/mvdan/sh").install buildpath/"fileutil"
    (buildpath/"src/github.com/mvdan/sh").install buildpath/"syntax"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "github.com/mvdan/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
