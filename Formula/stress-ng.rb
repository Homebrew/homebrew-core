class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.19.tar.xz"
  sha256 "a50b753f00a9c880eda4f9d72bb82e37149ac24fab4265212e101926a1c20868"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9de0e024c08012409f6656408e634d25022fa74921372032daa0800d68976a13" => :catalina
    sha256 "3c64e85a0e7ff1a57c13a2c1e56c55dfdfb20e95903004811404808aeb4638b8" => :mojave
    sha256 "81bff99b101fe0ad978bcb92da552a5395fba697330ef2de164c335aa45e347f" => :high_sierra
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
