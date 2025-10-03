class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.1.tar.gz"
  sha256 "4e6e76851dbf2606185972b53ec5decad68fe53b63a56e4df8b8b3c0a6c46800"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40650df0a281504caa67fa4fbab37755575808e9557d5fdd48f19580a8a64b45"
    sha256 arm64_sequoia: "a56a54ecdf856cb74c0c0d6645725c767c0b99eb99b9f0d61b86b6a22e6da0be"
    sha256 arm64_sonoma:  "b8304f6432ef8092ed55159c4d8bb3fbf4564c8a5cacddba2e42ddbc0c9b6ebf"
    sha256 arm64_ventura: "e4e5f167312e5627c114aa5fa2b596e75552401912ca233f4fa3da9c74d0bd77"
    sha256 sonoma:        "0d28db60e5d7cb42ac82fee32eb026b922d88f4bfe9a2ebbeb62585f6974d460"
    sha256 ventura:       "ada7a6b9202ebb004d9b91ceb90bc91104368308f952e4977b1f6f6af2dc81a8"
    sha256 arm64_linux:   "fef09dd91fa5de23b2f87a6df3f70917ae514b0a938790ae1dc2fa8f9b85a7e3"
    sha256 x86_64_linux:  "eda92c5a5f4093e2a6e5958b244dfef503a873af36d7c78140adcfe62ec31c21"
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
