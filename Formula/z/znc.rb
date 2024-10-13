class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.9.1.tar.gz"
  sha256 "e8a7cf80e19aad510b4e282eaf61b56bc30df88ea2e0f64fadcdd303c4894f3c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "9fce3b5382b0380bd66254957e18fb3267cb018171b9036d310e66e87eb4024a"
    sha256 arm64_sonoma:  "ca7e81f997a2088cf8be05e8d91fa58cf1624c10a380af761183cf4e56874e3d"
    sha256 arm64_ventura: "32335d86196df89e0b2cf68b111267f04b14f258c0393fe0eaf86add7c1950e8"
    sha256 sonoma:        "fd03a0c2c63620847014975e8a4ee5e9c182a5a60e936b3b1970545d4fbfb816"
    sha256 ventura:       "f92a3827ecaf2aac78a5ff213cc1aef5bb11b11e8dd185ff60b933497659f916"
    sha256 x86_64_linux:  "8410bceeaa10743e520ba2cb0e9e160a0a689d9096a6a2134ff0f58873326f2b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c@75"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def install
    python3 = "python3.12"
    xy = Language::Python.major_minor_version python3

    # Fixes: CMake Error: Problem with archive_write_header(): Can't create 'swigpyrun.h'
    ENV.deparallelize

    args = %W[
      -DWANT_PYTHON=ON
      -DWANT_PYTHON_VERSION=python-#{xy}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
