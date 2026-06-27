class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.2.tar.gz"
  sha256 "5b7561f3b100234d58ae4946eac0262ab305d275c094e64ae723e45d07be08ab"
  license "Apache-2.0"

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7b985e14014b37ee120b737ca0b9b84dcaa565b0c342ae90af884162fb0c375f"
    sha256 arm64_sequoia: "fbe274c495679f902a8263fc1081e2134fbef8bbf1fffc2c5264eaa3b939d158"
    sha256 arm64_sonoma:  "aa5f1213e70ef209fa9ac4b90c2693656e44528e8c5e7d3e1843a8dd31037a0a"
    sha256 sonoma:        "b478ce6112a959b7a6fdac1a9cecfa28eb88d815b6625a60692893f96c32d68d"
    sha256 arm64_linux:   "6a483a5695ba0f3b84d3b93f643e3f28baff5cb3d8371641ab8b019d39498682"
    sha256 x86_64_linux:  "2e27c54efb755011ff972394b1bbb7ef7cb7ce2f43123cf3efb05c5b6880f57f"
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
