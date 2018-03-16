class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.3.0.tar.gz"
  sha256 "7fac5b1d054f39f68440b19752321a59f41085b767311bd978cdcb107730ff8e"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6d12b60f099a4667ac5ea9c492dbe8dcca4a8dd8bc1f0e725172eb77d849d8c" => :high_sierra
    sha256 "b890862f53c7914ba0252ceb8e2c085a247bc093b38190c073189d36388fe621" => :sierra
    sha256 "1f59bdeab9980d8e504c6f89ba0f9674891208f017e36942bf79220e130bb443" => :el_capitan
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
