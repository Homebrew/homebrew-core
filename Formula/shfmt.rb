class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.0.0.tar.gz"
  sha256 "8bfd0d4b4d532d0b6ecd77f94c91d1f6da47b26a4453ed5c7567826113424116"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31b526255ecd8a4fe944c7ca3d7d757cd55d30235417d84ca39c071f149a0004" => :catalina
    sha256 "15b43658df24bf448ab0d3373ee75ab6e6af1e101ae684019fd9830a169fc48c" => :mojave
    sha256 "c18cccddb9678d23261c99b8a9870bc8ac98c74a332f6263eff670561f620a7a" => :high_sierra
    sha256 "ab8acee13bd584683347201a04cbef8b652fad596bbbc3374d153fb315cd4d88" => :sierra
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
