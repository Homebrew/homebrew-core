class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.1.tar.gz"
  sha256 "4e6e76851dbf2606185972b53ec5decad68fe53b63a56e4df8b8b3c0a6c46800"
  license "Apache-2.0"
  revision 3

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1e2747232b52e744dab03602e2c64f7e597f1f88137776f4b0a0c8dc7f64c267"
    sha256 arm64_sequoia: "dd385047888682db30c1faf5154c5f8e57b43730fc82bd9caa9787603a483126"
    sha256 arm64_sonoma:  "47341f5d07357a6bd1da686a3e729febc24d5e4e4bd35024c30cb67662429c51"
    sha256 sonoma:        "476b92c741b5434cb920cc71c994905c59310f38758defb7a22bf9e03abc2b40"
    sha256 arm64_linux:   "bf6d1c94f945793eb5f7120673ca4ebe155533a1548874f3781c73a849698ff0"
    sha256 x86_64_linux:  "d753d6a0086085f22ac70f0b74d604ba8dbc0816052daa298b3daf472f5f8e93"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@78"
  depends_on "openssl@3"
  depends_on "python@3.14"

  uses_from_macos "zlib"

  def install
    rm_r(["third_party/cctz", "third_party/googletest"])

    python3 = "python3.14"
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
    assert_path_exists testpath/".znc/znc.pem"
  end
end
