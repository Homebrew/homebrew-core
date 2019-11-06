class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.6.4.tar.gz"
  sha256 "72c8e5833e61a31a4595bbd8a77bfb0a8ade9c60603638be70ea801e309d39fe"
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
