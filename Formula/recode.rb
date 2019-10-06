class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/pinard/Recode"
  url "https://github.com/pinard/Recode/archive/v3.7-beta2.tar.gz"
  sha256 "72c3c0abcfe2887b83a8f27853a9df75d7e94a9ebacb152892cc4f25108e2144"
  revision 1

  bottle do
    sha256 "104914c7dd2db1afbafe61a025ebe41da5a88ed89ac8079c8e7d9150bb7a2e2d" => :catalina
    sha256 "541408c872b2c16e999cb6f74fc94e8c340dfb1e2eb3a89aa21d3f118554219d" => :mojave
    sha256 "65d9921e28f36fe7a0755d1cab44e4c2d2e5752ab25ed6c35cc7ee9e9072aee3" => :high_sierra
    sha256 "d8d1838e5484c1bbdde1a1f4f57907a601ee32b6577c3c9364dde06e095a5605" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "gettext"

  def install
    # Missing symbol errors without these.
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lintl"

    # Fixed upstream in 2008 but no releases since. Patched by Debian also.
    # https://github.com/pinard/Recode/commit/a34dfd2257f412dff59f2ad7f714.
    inreplace "src/recodext.h", "bool ignore : 2;", "bool ignore : 1;"

    cp Dir["#{Formula["libtool"].opt_pkgshare}/*/config.{guess,sub}"], buildpath

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-included-gettext",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
