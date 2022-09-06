class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 arm64_monterey: "86f16a8674a30c3e90550bc91a28632164ca79a20e6406f041522283290e2b18"
    sha256 arm64_big_sur:  "ce595569c4393a9afaab51ec09bece8e338f75ad8243980e23f687067507d15f"
    sha256 monterey:       "1738261be08afd3295e26952aa3fd19acb41a721d6ee44c4959ed80559d66d5e"
    sha256 big_sur:        "dd4a689a0b7de986f26c8ca48b7329bf18b43a25f521fc74480cc6e062bf850a"
    sha256 catalina:       "9728d7dd39d424732c3c49d30cbb30885d1d15e88691cb9afdeedaac0c2f07de"
    sha256 x86_64_linux:   "96cde551ca97b5e13566a245d7e3beda68bad19bb9bd7f5c629d73976f0d3bc5"
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
