class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.0.0.tar.gz"
  sha256 "8bfd0d4b4d532d0b6ecd77f94c91d1f6da47b26a4453ed5c7567826113424116"
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
