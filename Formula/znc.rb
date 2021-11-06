class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 arm64_monterey: "48bbc131756030fa8073447e12ac4d17dd02ef000510bb60d423bfbdee8618f0"
    sha256 arm64_big_sur:  "f6976cbbb65b4261db7ca3ab26c4f442096dde743a9fd63afe282d551faa07b8"
    sha256 monterey:       "557bd2025ab422e1f45779d35ffc7448f2f3be13ec5bdf686f5416c50fe67f46"
    sha256 big_sur:        "5ead56d8a9fd75e5c76cf96ffc0351c4a7a6cb91d6e6ae1dc35e55c8c410e734"
    sha256 catalina:       "6f51d8c1b693434a4faf554c20bcf05ba98cb147058fd1ba35a666839329dda6"
    sha256 mojave:         "d8dc6d3095a4fc27d77baa19cf870922374b701a41cf503170f7f99012d44acf"
    sha256 x86_64_linux:   "38164d05dbeec581b58630e44faec2766290d7e8c50959e8559a5fc317b5bb65"
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
