class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 9

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "11a519194072ba21ad36541e8e559f514e9a185cdc0c270b327effa16512e45f"
    sha256 arm64_ventura:  "715cf941fcfc7e6996e0cb9fe82ff0a95afb4a6e29e73cb863a15b1cbc9a081a"
    sha256 arm64_monterey: "55953112dd96fdf3be0928d482f0f54192a20b47e6277cec4aa8d4b29bdca792"
    sha256 sonoma:         "c6828c6787e7acce32fc13363d2102d2fc3813cd4228456db4563720d7916311"
    sha256 ventura:        "6b48dd78c1b5e606ce0e40380806dc57eb361052d8a8b4b3767033b547df9f07"
    sha256 monterey:       "b4c9210d6ad3fbecb1671ac6f449970b926bf8b23ce47c7dbd8acbc9ffac0256"
    sha256 x86_64_linux:   "a98c0ee38419f421ac3380517735a45263a21dee7ebb2bffa87d0f182ce2b632"
  end

  head do
    url "https://github.com/znc/znc.git", branch: "master"

    depends_on "cmake" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def install
    python3 = "python3.12"
    xy = Language::Python.major_minor_version python3

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

    if build.head?
      system "cmake", "-S", ".", "-B", "build",
                      "-DWANT_PYTHON=ON",
                      "-DWANT_PYTHON_VERSION=python-#{xy}",
                      *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    else
      system "./configure", "--prefix=#{prefix}", "--enable-python=python-#{xy}"
      system "make", "install"

      # Replace dependencies' Cellar paths with opt paths
      inreplace [bin/"znc-buildmod", lib/"pkgconfig/znc.pc"] do |s|
        s.gsub! Formula["icu4c"].prefix.realpath, Formula["icu4c"].opt_prefix
        s.gsub! Formula["openssl@3"].prefix.realpath, Formula["openssl@3"].opt_prefix
      end
    end
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
