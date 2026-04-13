class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.1.4.tar.gz"
  sha256 "e025d623aa253e20b050164e65f140e437c110812a7b4c8b1b1342f692dfb452"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bf97c7e756328e63323b19e86f4f9714c4b1fbd8c0233571f607ae61b5d9b123"
    sha256 arm64_sequoia: "5cbccd8e6392b2fc88394097cb0324be6e0841da297dfeb388f962e65ea43c01"
    sha256 arm64_sonoma:  "e8f717f671dc2c56cc34cb75389292777ea75644fb3403b14ae7fadb454b3303"
    sha256 sonoma:        "2c6afd27b4423d9dc19a13a61da96313bf0c5558ed0612c2a4359bc338213362"
    sha256 arm64_linux:   "db8e4402c17bfa8c31e4d263beb353d19c74bde0490e014888134543c7476b4d"
    sha256 x86_64_linux:  "9cb7f044d403e5d74ba277ca4eb40bd53b5d8b27e3a7efcaa25021d58f853141"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
