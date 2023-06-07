class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.8.2.tar.gz"
  sha256 "ff238aae3f2ae0e44e683c4aee17dc8e4fdd261ca9379d83b48a7d422488de0d"
  license "Apache-2.0"
  revision 7

  bottle do
    sha256 arm64_ventura:  "ed4a634c5c2c63205e7266a19c6d685d0aa68edddcb7ee337073d5ad3c028b73"
    sha256 arm64_monterey: "ed52dfc980e89f83ce8d96038e9123e4bf4074d458b7205772406e2e03c2180b"
    sha256 arm64_big_sur:  "272d6a5fcfd50861b6bdcde9b3100966bfc4ab4cdf2c5263c351d62f24cccaca"
    sha256 ventura:        "c298279b0e0dd9a7db7c23bd73da4e5520b7ffb945085774b04ee7a2744a6632"
    sha256 monterey:       "88007325bf3297291131273e6b504deb990e5fd2650163177d81cdf45c3b37fd"
    sha256 big_sur:        "7964958863be063aa002f7998e4477a18c028ff61550c9501bb564293c89046b"
    sha256 x86_64_linux:   "88497ca54899330c2add08f3ba87d4e4d75d508eb90da2afdb135bd523e17786"
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
