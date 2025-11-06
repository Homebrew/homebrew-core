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
    sha256 arm64_tahoe:   "632756fb48b0fffafa9475a050161c4eb8a4bf59757e9acc61d783774c201819"
    sha256 arm64_sequoia: "8bd7d993632e09424278354b9524f86d17d54bc108d9b4e13ebf0a00694fe5a5"
    sha256 arm64_sonoma:  "6746a8d979027c3378889ffc5b9c14baf4d18a2c1dd7e9574bc695377bd899b0"
    sha256 sonoma:        "c792361538ef5fabf89946aa8392831514befe4cedda867bf9a3ce4c5f388ec0"
    sha256 arm64_linux:   "961ec6458b904b9d1d98c6a7ac617d1c09d2226082c8b6d3c6520694e6c2a63b"
    sha256 x86_64_linux:  "7dfd938d455a6e79801bfe124e68bde87f66f99c1251c2fe0550f821c2587a7f"
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
