class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 arm64_ventura:  "f357cdf31351b0fc786625edd3eaa79479d84b804dd88e457f26973c5a393a8f"
    sha256 arm64_monterey: "9f265070a97162748e9a31b24d5b00fc98addeae4b43f4adc2f439e9d008af92"
    sha256 arm64_big_sur:  "cfd07853704d8ae2dc9c7a484ca35703b337adb71e0aaf24cd9e4d5ebea3fb91"
    sha256 ventura:        "aed8a3f4c7dde5770c52add44e411e91b1b3c0971cda9ecb88ce41cccb0ce079"
    sha256 monterey:       "1e5c0ddb80231c37f7c2543caa3b817877e6bacece964669e5de73e7d03d4969"
    sha256 big_sur:        "df61314f1285c3614690eef04aa483981278c7519efad267ad4032978d6f5ff9"
    sha256 x86_64_linux:   "71ea50d73c6a06d67bf9500d0c8bc55fc5a3db67fdf5a9a72997e3b7f86fa2ce"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "mlton" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "openssl@3"

  # Patch to fix build for icu4c 68.2
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d7db3f02fe5dcd1f73c216efcb0bb79ac03a819f/urweb/icu4c68-2.patch"
    sha256 "8ec1ec5bec95e9feece8ff4e9c0435ada0ba2edbe48439fb88af4d56adcf2b3e"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "SITELISP=$prefix/share/emacs/site-lisp/urweb",
                          "ICU_INCLUDES=-I#{Formula["icu4c"].opt_include}",
                          "ICU_LIBS=-L#{Formula["icu4c"].opt_lib}"
    system "make", "install"
  end

  test do
    (testpath/"hello.ur").write <<~EOS
      fun target () = return <xml><body>
        Welcome!
      </body></xml>
      fun main () = return <xml><body>
        <a link={target ()}>Go there</a>
      </body></xml>
    EOS
    (testpath/"hello.urs").write <<~EOS
      val main : unit -> transaction page
    EOS
    (testpath/"hello.urp").write "hello"
    system "#{bin}/urweb", "hello"
    system "./hello.exe", "-h"
  end
end
