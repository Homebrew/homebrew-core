class Sispmctl < Formula
  desc "Control Gembird SIS-PM programmable power outlet strips"
  homepage "https://sispmctl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-4.11/sispmctl-4.11.tar.gz"
  sha256 "74b94a3710046b15070c7311f0cacb81554c86b4227719cc2733cb96c7052578"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "b2075769774a1af1d66280ed8561445b461549beaa3c035c6d9ec16f811a7369"
    sha256 arm64_monterey: "0b1440bb353b930e64ef9d397e73384e3ba9eede714d8b9d77d5db155eb89cf5"
    sha256 arm64_big_sur:  "448b754e8f3a66f3d0c9a00a398e3cc1f7c45f83b59369a3339299c8551f4602"
    sha256 ventura:        "ac442280a1b9009303967a63e4e05768699344bd6c9164a443ec936f04bb30ca"
    sha256 monterey:       "f1982090b769e79c2deed3ca3fe200d451e3d2cd9a99b699d0b485d76aa04214"
    sha256 big_sur:        "5fdb85ced862856b67a8dde724af9974e82d8700a880cb3c9b19f2faa19a3a02"
    sha256 x86_64_linux:   "49964c1c7eaa4bf16e7022640f6b98624a88337624b7cfab3c4a61d2b17682fc"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sispmctl -v 2>&1")
  end
end
