class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.1.0.tar.gz"
  sha256 "2f39dc1d34e87190b659ed677a83e32f9ef769cd8adb34f8c4ccf0a9091b109f"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3058f1b2fec677ad43054cd5cc7b9403d79ab94337a11093c01780f5489b0c3b" => :high_sierra
    sha256 "2d55298e924a8dd9637dfe7c075d1b00d9b1027991ab69884501a71058ae507c" => :sierra
    sha256 "2dd308282492d562fc7fec70e55b7d8b34132374e89f639cdb8bd86565438aef" => :el_capitan
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
