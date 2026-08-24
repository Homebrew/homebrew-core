class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.2.tar.gz"
  sha256 "5b7561f3b100234d58ae4946eac0262ab305d275c094e64ae723e45d07be08ab"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "52596a383127e6c174e4a1ee5b8a28b2eacc7f3c90a7ec88e26bb2543fa937ff"
    sha256 arm64_sequoia: "5ce07766fdc5057aec916ea1256c08452f6a82376cdc18926cd1d2a94db0c78e"
    sha256 arm64_sonoma:  "5a50bdbb7bd123b07b905061ae9757e35e5cd40edf88f1aa3b010ce0f8a0d586"
    sha256 sonoma:        "71493cc6f0ace695dd09c6cb652ec31e285a0133053c81708b92eb9211f43a32"
    sha256 arm64_linux:   "e27bd1d958cff96750999564bf636a9fd9a700ecfd300fcd1f553d7be5271156"
    sha256 x86_64_linux:  "367231b8d2151bd2beef09cd519629c5b6a568c8d7ffd6d10b229c5ada7dfacd"
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
