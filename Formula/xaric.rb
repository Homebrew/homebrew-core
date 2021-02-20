class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.7.tar.gz"
  sha256 "fd8cd677e2403e44ff525eac7c239cd8d64b7448aaf56a1272d1b0c53df1140c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xaric.org/software/xaric/releases/"
    regex(/href=.*?xaric[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 big_sur:  "d832ba1dd3908ef0d452fd2cf7af23e871d2bc93ce45bc3bee23417096724b6d"
    sha256 catalina: "b1247cee2be64fbf7fe5c1c76e7dd009b2a05538fa6e3fea047a6887ef7cffe2"
    sha256 mojave:   "8157b44f1d6a36035ac047e976c64e56b1c98d15f2e883f36bd033b1e0335ec4"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"

  def install
    # Workaround https://github.com/laeos/xaric/pull/10
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Xaric #{version}/, shell_output("script -q /dev/null xaric -v"))
  end
end
