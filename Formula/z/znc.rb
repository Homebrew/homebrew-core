class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.9.1.tar.gz"
  sha256 "e8a7cf80e19aad510b4e282eaf61b56bc30df88ea2e0f64fadcdd303c4894f3c"
  license "Apache-2.0"
  revision 5

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "0861238c72cd5397e1568a741f8ac0339b00e573e3b799ffb223d665fb3b5e12"
    sha256 arm64_sonoma:  "2465789ae2561cf508f38ca0867f67188fce03bc5548ec5a01e4858de66d9884"
    sha256 arm64_ventura: "65b535ea5a67a4861e94c69b0caad4c082a8798ba68684fe62b9565d762fef23"
    sha256 sonoma:        "a6d475310180f77f8ffcc744a0c37f3165c4b1fa995a1f40d1d24ad3a44acf73"
    sha256 ventura:       "33da8af5b2f1dfed9dcc1948da42671ed4ccd73c2fd5dfc717ce09d9e408f978"
    sha256 arm64_linux:   "f9b89d45801edeb21325f98eb1ec5c49363cd5649aaa8dbf0e27b55c061faea9"
    sha256 x86_64_linux:  "bdd3624bb4903a647648c3f9efa1f2c1d5e383d9f29024771fe3a6eb1395d4d5"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@77"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
    rm_r(["third_party/cctz", "third_party/googletest"])

    python3 = "python3.13"
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
