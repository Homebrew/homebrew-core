class Znc < Formula
  desc "Advanced IRC bouncer"
  # Temporary URLs as znc.in certificate has expired
  # FIXME: homepage "https://wiki.znc.in/ZNC"
  homepage "https://github.com/znc/znc"
  url "https://deb.debian.org/debian/pool/main/z/znc/znc_1.9.0.orig.tar.gz"
  mirror "https://znc.in/releases/archive/znc-1.9.0.tar.gz"
  sha256 "8b99c9dbb21c1309705073460be9bfacb6f7b0e83a15fe5d4b7140201b39d2a1"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "ece54a18459b4d498a699278daef03cae8f37d008645313afe0116e9e5a5f263"
    sha256 arm64_ventura:  "6caf5ebc8490cb565f951e1eb14f24da2dc3eddd0e510133db6325b788e8656c"
    sha256 arm64_monterey: "6120a847b16ac4bca100f332c3a4ad9c64b000de89d757979533ed04a97b955f"
    sha256 sonoma:         "3af5963b24f8444d3ab144bb9c57c31950c6e1d8c22dc4a4a25599f59a937f51"
    sha256 ventura:        "e98891934fcbeb85ac8d80d9b44df2fe0a6de07a4a9aa1d9d8a0f537d76fd7c5"
    sha256 monterey:       "0b4ebe72752d4c810c3a2a6e335cab10ac3aca8676785344100baf6d8570bd61"
    sha256 x86_64_linux:   "3541c695090d2e083f89ca537df3925d7dd8884e656425f3b533bb65f724bc77"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
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
