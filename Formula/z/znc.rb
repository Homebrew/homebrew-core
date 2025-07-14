class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.1.tar.gz"
  sha256 "4e6e76851dbf2606185972b53ec5decad68fe53b63a56e4df8b8b3c0a6c46800"
  license "Apache-2.0"

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "3f879e3a53f671bf91948290672d9afc4b2c525be1a8391a8edcc579c23a1367"
    sha256 arm64_sonoma:  "f352b0898686f3e1971ac5f93838267f3f25cc7c5dbc21339866f27d764da5f5"
    sha256 arm64_ventura: "0559e03b2e5cd7017a819de05f004344156598ca0df4e1a645123cdd61aa0a3b"
    sha256 sonoma:        "53321095073216bd88a4065e2ddd853d6251fd20ed747833d99a5592eb1f3606"
    sha256 ventura:       "eadae1e71666ba8f013eb2080e91cce2f34d6e2b0113710cfbcc4b6425b0a1d7"
    sha256 arm64_linux:   "b2567236b256be9c054c3c51bbb8ba3ec2072137e5d80ebe44414ea5fe33bd4b"
    sha256 x86_64_linux:  "22d73b1c7debe47b930d2cf16eec7cb509d450c4f01c5e8ba2d6babe3be95a53"
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
