class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.12.tar.xz"
  sha256 "0ccf437ca1876a3e8a55986c6481697045203a17f5994cb2f5096cd461d18031"

  bottle do
    cellar :any_skip_relocation
    sha256 "d05badd86529778db39038c6a653bbd5499893bb4d5dc3e4a8b45c352b390983" => :catalina
    sha256 "d1388a88881ef24d18563640417dea348e7484ff97c766fc54c97049d9574dcf" => :mojave
    sha256 "7eb634f6ac243b8f4822b16506fb3bc83d467c7d4d122e62e04555f174983ab7" => :high_sierra
  end

  depends_on :macos => :sierra

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
