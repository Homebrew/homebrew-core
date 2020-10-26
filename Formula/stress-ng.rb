class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.22.tar.xz"
  sha256 "408153d64be1d8a8d584e5f48d9fd09602adf4095a17c0b542cb41e636cf0464"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a5fcbf438fbc92ac189247622e85a3adb66ab44b51f15604d058aec66834601" => :catalina
    sha256 "8be72e18cc21d8158f5f691072c5eada3447a32eb11d634f1e62bf8fa339b2b2" => :mojave
    sha256 "3a5daed865d2b499174fbb904d0181201386f71746df7df291af3919b5a19e5f" => :high_sierra
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
