class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "https://www.jedsoft.org/slang/"
  url "https://www.jedsoft.org/releases/slang/slang-2.3.3.tar.bz2"
  mirror "https://src.fedoraproject.org/repo/pkgs/slang/slang-2.3.3.tar.bz2/sha512/35cdfe8af66dac62ee89cca60fa87ddbd02cae63b30d5c0e3786e77b1893c45697ace4ac7e82d9832b8a9ac342560bc35997674846c5022341481013e76f74b5/slang-2.3.3.tar.bz2"
  sha256 "f9145054ae131973c61208ea82486d5dd10e3c5cdad23b7c4a0617743c8f5a18"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.jedsoft.org/releases/slang/"
    regex(/href=.*?slang[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "efee4508d1dca5519b52de6bea66a589bcb203c62b826101fe599e4f3862f149"
    sha256 arm64_monterey: "5378418e6b6e974287ded1bc8f6ecbcffe4dfab01ac35c92a1f83336d0d49270"
    sha256 arm64_big_sur:  "c79914984d5c401d8fed000d07ca34b914ae585461c86be3672e3172d5035f9a"
    sha256 ventura:        "cbb5b0a2f1b1821be50e9c3ca7c01811ad60ddfe49c2c022cf486399f664e994"
    sha256 monterey:       "66e107f60db823f566bf6d2101fca2b2aff3b572312cd34a9a86b0cdba47adcd"
    sha256 big_sur:        "71450b5ff5941e3b2f6a8ca4864affbf8fa5c50b4753860ca86e596834618638"
    sha256 catalina:       "658b0b6498b5c7f7c65c8d5ca99ee601dcfd4c9978bb7961613a1a9513f78609"
    sha256 x86_64_linux:   "6e07e31addec7d56674c850019014a1b529cf4f869f47f3c247a9d490982a13c"
  end

  depends_on "libpng"

  on_linux do
    depends_on "pcre"
  end

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
