class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/pinard/Recode"
  url "https://github.com/pinard/Recode/archive/v3.7-beta2.tar.gz"
  sha256 "72c3c0abcfe2887b83a8f27853a9df75d7e94a9ebacb152892cc4f25108e2144"

  bottle do
    rebuild 1
    sha256 "4deb2f8480290e89de9b611eb139b7bd93d4279b776ca53ef32f31017d023d61" => :mojave
    sha256 "ca77219ffb6960de21caf333f31faa43de430a0e9f784624324a7c0581ce567d" => :high_sierra
    sha256 "15572a6826a49109bd64fd9b50eace8259a7563f9e6ffdbf5112ed742a256c79" => :sierra
    sha256 "1aaa7262ed6614a56e2bc17ac4b518903b62eb582d6aeab45f7845b38dee224e" => :el_capitan
    sha256 "8518f350264f5cdadfb26c49487f82f9c159307f26d10230daf415d1495607f4" => :yosemite
    sha256 "81fb3b36d647c6dd83f9fb65bf657b73b65d551a16dcd7e9552ff70f5a1394dc" => :mavericks
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
