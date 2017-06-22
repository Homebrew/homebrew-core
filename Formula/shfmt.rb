class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v1.3.1.tar.gz"
  sha256 "322768c53a2e83f84b69e9f85dd9865d60d3001244c4a6b6a15ff779c6bd8b4a"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3900ddb7c8a1e991088438c1192a8d677d3887af8e841d8e38102d54dca828b9" => :sierra
    sha256 "e9886469456fa743b89f9b586c3042479fe08291f8d52b91b1f3725df079b1b1" => :el_capitan
    sha256 "90a9775ab847b5d4bd6584c142f19a9d3d4c8073a409a3e0ff1781a880ded6f1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mvdan").mkpath
    ln_sf buildpath, buildpath/"src/github.com/mvdan/sh"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "github.com/mvdan/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
