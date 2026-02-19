class TokyoCabinet < Formula
  desc "Lightweight database library"
  homepage "https://dbmx.net/tokyocabinet/"
  url "https://dbmx.net/tokyocabinet/tokyocabinet-1.4.48.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/t/tokyocabinet/tokyocabinet_1.4.48.orig.tar.gz"
  sha256 "a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?tokyocabinet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "4443340968f13e90acfd2e0491be08daf43624bb64554b72d8f36997013650de"
    sha256 arm64_sequoia: "972d0577b287658d7e6998da98ca2ec90a4f556ac8477b6d2bf0715a9a3a53b0"
    sha256 arm64_sonoma:  "ff7f8db793fb34cab4df2f1d8b5a5c69493c331a04f43df07d6cf4852fabc29e"
    sha256 sonoma:        "b40efcef4f5fd2f20b089c0508f846118c2d201139cb83dfdfd66195b7268c7e"
    sha256 arm64_linux:   "a0345079ed1d67a3d20844ebefe5b7a2140fc302824523cf7a194f9ccf848cdb"
    sha256 x86_64_linux:  "049e05440f7039b0f3bf2bde34a891a00cac26da036d7a8cf74fae2cde43d2c8"
  end

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
