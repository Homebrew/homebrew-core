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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4501b4277af6a136a6ac81ee096feacf8e8a9d32324482f9b9cdb60ec9b513e2"
    sha256 arm64_sequoia: "3d8e852f17793468f76777ca0fafbc7cb43bc45ba3abc5e2a31e177918be143f"
    sha256 arm64_sonoma:  "faef8261bcc436c422dcc8e125d851a246860356f53c80aef017048a99e21d15"
    sha256 sonoma:        "8e18a9ad12b0db57d0b46bd3342c1aadc4c0a662ed47d5900961576f2a99e0f2"
    sha256 arm64_linux:   "5a14d1dd14b8bd40405616172456dfc0cc8b3af2bfb873e7a8853e07c27c8f5e"
    sha256 x86_64_linux:  "72a9f13d969bd75373501dbac11238d2b4a7fcbc934624f50b14ad6f5185c22d"
  end

  depends_on "libpng"

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}",
                          "--without-pcre" # avoid EOL `pcre`
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
