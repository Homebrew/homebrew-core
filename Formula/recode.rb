class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/pinard/Recode"
  url "https://github.com/pinard/Recode/archive/v3.7-beta2.tar.gz"
  version "3.7-beta2"
  sha256 "72c3c0abcfe2887b83a8f27853a9df75d7e94a9ebacb152892cc4f25108e2144"

  bottle do
    sha256 "e52c773b4472c6a8f23678cbdb69cb2c4a8f4b78a1f1a5a0fdafc97b3ffa30d2" => :yosemite
    sha256 "c02fc6ad41698d029f251cf6b7218f7e6f9778e97406efade13027860613424d" => :mavericks
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
