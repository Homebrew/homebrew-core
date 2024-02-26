class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.9.0.tar.gz"
  sha256 "8b99c9dbb21c1309705073460be9bfacb6f7b0e83a15fe5d4b7140201b39d2a1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "152c9f40d2b5b6a0806da2e8dd9f03d90ab5a0c672fd9fb820d6e45900e0575f"
    sha256 arm64_ventura:  "de305bd37409256dbf785aac9402c030748874ae0e4adbf7cd7ebb07605f823f"
    sha256 arm64_monterey: "3f2c85f879c34eb86b044ed70f745cda8973a348e52b1b0e459b3464eea5cc1e"
    sha256 sonoma:         "9072fa0a151e0eae9a78a77fea832d77a685bfc1a2fcace1dbc31e21c8aa2f31"
    sha256 ventura:        "a8bb46b0a2c44b15569faee250c3ec0071f85791728cd9a1009f0feec0838fa6"
    sha256 monterey:       "ff8d6542512169652c2e0b3adf6dd9ab24cefe69151aebf14b60dcd2fddc93db"
    sha256 x86_64_linux:   "2ba9392d0183ab430915828c24953348649cbb2a10852e4be5c9ea11108517c7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def install
    python3 = "python3.12"
    xy = Language::Python.major_minor_version python3

    # Fixes: CMake Error: Problem with archive_write_header(): Can't create 'swigpyrun.h'
    ENV.deparallelize

    system "cmake", "-S", ".", "-B", "build",
                    "-DWANT_PYTHON=ON",
                    "-DWANT_PYTHON_VERSION=python-#{xy}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace lib/"pkgconfig/znc.pc", Superenv.shims_path/ENV.cxx, ENV.cxx
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
