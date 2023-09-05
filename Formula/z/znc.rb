class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 9

  bottle do
    sha256 arm64_ventura:  "9d22b6e33c6538bab946604ba4317459e185897e2f2ae491cc7b66076073e065"
    sha256 arm64_monterey: "ed9dcc7af9880176e7a29ef421c4acd240160ddd67920bd6649aa158b9e37bc7"
    sha256 arm64_big_sur:  "1868c389351fd86e5c9c5847974b57007fd794819213f864d1854fa5d4139db0"
    sha256 ventura:        "b553390d14bff7112a6bc0adae40d427cccd0a1ba3a01f69ad8a5dea698bc5e2"
    sha256 monterey:       "5365f2987a95d6a84b0e7e1137903f25d8b8f20d69003c9ddbbee1bcd92d4a9a"
    sha256 big_sur:        "ad659f597cbbed3de79d83d580d4f65608ff342b18a95bf971f4cc3818470ec6"
    sha256 x86_64_linux:   "4b7acf8d5d88524f8091a79a19cbfd2b8ac1ba89cb0245f4cac579fad82d7961"
  end

  head do
    url "https://github.com/znc/znc.git", branch: "master"

    depends_on "cmake" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
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
