class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "https://www.jedsoft.org/slang/"
  url "https://www.jedsoft.org/releases/slang/slang-2.3.2.tar.bz2"
  mirror "https://src.fedoraproject.org/repo/pkgs/slang/slang-2.3.2.tar.bz2/sha512/35cdfe8af66dac62ee89cca60fa87ddbd02cae63b30d5c0e3786e77b1893c45697ace4ac7e82d9832b8a9ac342560bc35997674846c5022341481013e76f74b5/slang-2.3.2.tar.bz2"
  sha256 "fc9e3b0fc4f67c3c1f6d43c90c16a5c42d117b8e28457c5b46831b8b5d3ae31a"
  license "GPL-2.0"

  livecheck do
    url "https://www.jedsoft.org/releases/slang/"
    regex(/href=.*?slang[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "683b24e8ece6c1df5e4128a5214c34b37680100f4f6c89300ee698df9d92321a"
    sha256 arm64_big_sur:  "6edfb9a9ded33b0e5d96c83a0e9c5728be728588427aeff1d964b1191233ff45"
    sha256 monterey:       "6b709b8659bf81523f0ebdf49c6312a542da013a1be962a6dbfaae1e766d1ecb"
    sha256 big_sur:        "517b401933d5e4359b6ad212914b54ff5d6d28ce345b63f0f712838cf97f8925"
    sha256 catalina:       "4753499f91b8d6ad4f17865ba850eb5f170aff6460441655c75838b759b2ff9d"
    sha256 mojave:         "05a3437702d5793c9bcac94151e8614878ca36cb1074ab330708021e59845346"
    sha256 high_sierra:    "52884a38833f21110f2ed22960f8f96ed5e3878fda45def8b67450e643ccfc97"
    sha256 sierra:         "e317f0ed56871fe293943faedfa44e6c744afb5a0187b7c81e201ce6921b0634"
    sha256 x86_64_linux:   "9404d0e56144f597b57af151b9a2a57a00a8d5f8e86fe8eaea8259628adb2736"
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
