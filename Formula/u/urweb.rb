class Urweb < Formula
  desc "Ur/Web programming language"
  homepage "http://www.impredicative.com/ur/"
  url "https://github.com/urweb/urweb/releases/download/20200209/urweb-20200209.tar.gz"
  sha256 "ac3010c57f8d90f09f49dfcd6b2dc4d5da1cdbb41cbf12cb386e96e93ae30662"
  license "BSD-3-Clause"
  revision 9

  bottle do
    sha256 arm64_sonoma:   "6b1cf20e87eb2695e60148e03f989674f8073e9b4122ca2e1fa11d2b73b6fbce"
    sha256 arm64_ventura:  "6f44ca686b493d46567ebf63aedc2872cb5ca20e1b72dad7d787c31e3d0fe98d"
    sha256 arm64_monterey: "b9837a19f85054bd9de1292aa7296fd083d2cc82fcca13547d51aeedbf79ecd7"
    sha256 sonoma:         "44774b48d96b86fd9e97a72604352a9e6cc0693b8da3f424316fb8ca91b48acb"
    sha256 ventura:        "46d566a14e0df6e6996327f164265fbd93208ffdcfb9701ffb9d02f37447233f"
    sha256 monterey:       "5cdc42d7c7ac69422f3dc1ab5b519ee3f817669ff30d4364b75f863bd4950e31"
    sha256 x86_64_linux:   "ae715d55e194246c5895fc01c83d897a7ee31a47ae0656c09c249e57f53f6a48"
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
    system bin/"urweb", "hello"
    system "./hello.exe", "-h"
  end
end
