class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 arm64_monterey: "a5cefafd6afb35a8088d63c38c7eaba3ea1f6bc03b32826c2e6c046bc3213b18"
    sha256 arm64_big_sur:  "9d363de93b8feb7187615978a6aca7630666a6b86fa3c2f5016bce5f48adf1e0"
    sha256 monterey:       "56b9619483c6d8214c9ae0647571440b86e9cd8a0f0074ec199f1217c848ceb0"
    sha256 big_sur:        "18eb1fb1b9e70de8db85ae790909ba5cdb61ebdea6d90b42c82df0372d46db19"
    sha256 catalina:       "da3ec87a956fa3141d7cb7051a7b9926d84947271e84ce664d130a8849e3d8e2"
    sha256 x86_64_linux:   "5e20a56f59e8da43b0f7e1b1f55ead1c82705ce6d8ef54be36b83b76482760c2"
  end

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

    if OS.linux?
      ENV.append "CXXFLAGS", "-I#{Formula["zlib"].opt_include}"
      ENV.append "LIBS", "-L#{Formula["zlib"].opt_lib}"
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-python"
    system "make", "install"
  end

  service do
    run [opt_bin/"znc", "--foreground"]
    run_type :interval
    interval 300
    log_path var/"log/znc.log"
    error_log_path var/"log/znc.log"
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert_predicate testpath/".znc/znc.pem", :exist?
  end
end
