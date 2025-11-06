class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.1.tar.gz"
  sha256 "4e6e76851dbf2606185972b53ec5decad68fe53b63a56e4df8b8b3c0a6c46800"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f3e591d177d67dfcf9862e28263c2a7e41bed67e068851e49bbaff9002dfadf2"
    sha256 arm64_sequoia: "b94c29f33a1caac275da0e4b696e17dca30a2a72ff7fe076aad048288ab90075"
    sha256 arm64_sonoma:  "4e10a3064792c123a98d2187233c3b0bb912e6374fc437b45848f6b66964bbe3"
    sha256 sonoma:        "0d63b728adcbfd850910495cd802a75fd88b7c5a807f317dc4167b676a7829b3"
    sha256 arm64_linux:   "8e7499140c420629555642ffb7c1d2da60176e1c0f2fee2b29540c0abd10fd1f"
    sha256 x86_64_linux:  "bf43c9ddc619177585d80befefb1cb090fc72baf95066caae45e0e80c3633ea7"
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
