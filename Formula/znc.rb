class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 6

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "1e1f3718f5abf66532f650cf7f1df3ddba587176c12b36c56f513cf50401ac35"
    sha256 arm64_monterey: "3a5652ad8b655725f9f824c2da28da03fc5ae0d4b3dd4ab666fa5377ba5ca586"
    sha256 arm64_big_sur:  "2e6656f598cf7512ebed68558ea8afd0bb785049ebca38ba2042dd2b81f1dd34"
    sha256 ventura:        "3f6d3c8bf68af7342697a5d5c2cd9d9a54f9e4407988834fe088ecf6098d9d11"
    sha256 monterey:       "c0220516ba0bf2a16b478ba7c1d2cd8c146f1f3cc5c20f053e8008556b5ca8f8"
    sha256 big_sur:        "da0f129f9308c52d466431eeb447e3f69ab2874f04508b0bc6a27923e4d3e179"
    sha256 catalina:       "5b0d7cd57c96889fe33b2969a7525eccb307f6ece0020bb00b9ac9430efdee77"
    sha256 x86_64_linux:   "e8943f612e971fb36d5a52c2f3f544902287c2b987bca67b72067850e0e6840e"
  end

  head do
    url "https://github.com/znc/znc.git", branch: "master"

    depends_on "cmake" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "zlib"

  def install
    python3 = "python3.11"
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
        s.gsub! Formula["openssl@1.1"].prefix.realpath, Formula["openssl@1.1"].opt_prefix
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
