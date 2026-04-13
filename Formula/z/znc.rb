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
    rebuild 1
    sha256 arm64_tahoe:   "afb9c0ccfe01f8d0c335ad33d7cb27d3bcff074ca0e22158d83caabf73bc7277"
    sha256 arm64_sequoia: "b74d2600ee42c8c0cbf9ba88c13be60fde6a8de877803a94a10f80a23018eb69"
    sha256 arm64_sonoma:  "ef62cd1a62388891aca94018dadc7484def7d0479d4714b3843898516892b85b"
    sha256 sonoma:        "25b53ba0a8aa7400cd84902fc9f9b871b81af26021ec417420384341b27d7c80"
    sha256 arm64_linux:   "f9a460da2c37ce2776fd85d3201a8ca6911cb423e94bf7682e67bb97f5c95577"
    sha256 x86_64_linux:  "d7cabd8dc640eb9161c5489da76eff509f3459bac957c427da009241c3dfeea7"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@78"
  depends_on "openssl@3"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
