class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.0.1.tar.gz"
  sha256 "4cca3d8a40e5132a4764a3bf7bcf335288ebff8a4a74e130f9359605e6f07544"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30be3ad12d6c8f8a89bdb474c73e1e200dd5a24139fc537ff5a12c2e13f28740" => :catalina
    sha256 "6f8b26710d4256b9e860623ad8c3a45a18aea37021a35bb57027e8e7b6a3a412" => :mojave
    sha256 "2a4bce87e84383b42a2f0362a213d46b38873c1295785af506401749ab39ab64" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags", "-w -s -extldflags '-static'", "-o", "#{bin}/shfmt", "mvdan.cc/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
