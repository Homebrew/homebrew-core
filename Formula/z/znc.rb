class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.9.1.tar.gz"
  sha256 "e8a7cf80e19aad510b4e282eaf61b56bc30df88ea2e0f64fadcdd303c4894f3c"
  license "Apache-2.0"
  revision 3

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "8e2a03b070797aebc5285ee44bc4f3b24b1e18ea7ede34b99c6d26ec6c10664e"
    sha256 arm64_sonoma:  "9186e3d185f82706175bf4092af6e0ee4829c90d758b374e3acfe95201f0c7a7"
    sha256 arm64_ventura: "0afd839114a50990b300740b36473128e79e15032f8b7074c1413c1efa763d97"
    sha256 sonoma:        "0532ab7f343c502374a812274d63cceb96e88a44a278bfaac02024f7768809b7"
    sha256 ventura:       "1124fe470899bc70a32f366b18edd5eb2d3d44827484b18113aa56664bebf7f2"
    sha256 x86_64_linux:  "1d7d7ecea3de12210ed78b1178d3e5afd2aa93f9ffb1985fb0df4ed70d795f0c"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@76"
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
