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
    sha256 arm64_sequoia: "44377fa4fab824dc91a14da204da3e1b7c549f6299d180ab68aa123ca471d0cd"
    sha256 arm64_sonoma:  "b5fadf44a225327d8b0e1b4949bf378bd4ce783884f0bffcc59518b734f21929"
    sha256 arm64_ventura: "caa374a728a369288be5b9582538dbd7f043e57a2629eb7f83c4b39ee2922a4a"
    sha256 sonoma:        "6a456589aaf33f7ba8528a29f66405a73350ae0ad3ed46358a7b37dfe3917971"
    sha256 ventura:       "246b93b260aa766a2579713e92374f9148efa7576a0b1b08ec4001660bbddf9b"
    sha256 arm64_linux:   "dbea2a2ef382edf3a81e40468d7101454fa9e91a0d2ab8ad1f1a0f8822ac4bac"
    sha256 x86_64_linux:  "112ccffa7fac288d64cf57f17a9eaf779821ec404d2c3ebe5b5f8ab15c2a84ad"
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
