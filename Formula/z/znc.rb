class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.3.tar.gz"
  sha256 "68f3f6641b480c041010c5596e1234043e05c9137eda06233845017603095f5b"
  license "Apache-2.0"

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "4f2a826ce0ded6b6712c07f7ef00522b04e29302a6d1c49ee7ea43595b015081"
    sha256 arm64_tahoe:       "eed95d97fde1c6da93568e57b40095651b15b0219f0664cafee92a8d3e4e8591"
    sha256 arm64_sequoia:     "5de378841c045102c6c5762476fbf36db9954400f11d9e5127dd555c960eb738"
    sha256 arm64_linux:       "094595c6536f2cec05f621e5ec02f5d7839caa704579811c0c22f52a3f4f5bd3"
    sha256 x86_64_linux:      "fcad025ae02cf535706dd314def9dac8f3f21b183a685dc93b735c492cfea482"
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
    depends_on "cyrus-sasl"
    depends_on "zlib-ng-compat"
  end

  def install
    rm_r(["third_party/cctz", "third_party/googletest"])

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
