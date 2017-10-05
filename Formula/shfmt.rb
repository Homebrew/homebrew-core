class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.0.0.tar.gz"
  sha256 "60b643135df5dc44721933ff6eb0863b5760db0b6da3a02c5659e58d01393f25"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7de33e97c91cc32f5ce4f63d6bd3511926b717cf209f024d24f8662e8174befa" => :high_sierra
    sha256 "3900ddb7c8a1e991088438c1192a8d677d3887af8e841d8e38102d54dca828b9" => :sierra
    sha256 "e9886469456fa743b89f9b586c3042479fe08291f8d52b91b1f3725df079b1b1" => :el_capitan
    sha256 "90a9775ab847b5d4bd6584c142f19a9d3d4c8073a409a3e0ff1781a880ded6f1" => :yosemite
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
