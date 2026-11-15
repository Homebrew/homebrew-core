class Rawtoaces < Formula
  desc "Utility for converting camera RAW image files to ACES"
  homepage "https://github.com/AcademySoftwareFoundation/rawtoaces"
  url "https://github.com/AcademySoftwareFoundation/rawtoaces/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "1687f12ce34c3d01d5e3d293dacf14df3d815d51d4595c12321d0262a5adc792"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f94c9904d3951ffd910e73561d46b6c81eb6c754a23e0192e087823256968776"
    sha256 arm64_tahoe:       "6ed26bc049d6662d7083a4e1f59dfbb953632236fc89848040494255c6d701df"
    sha256 arm64_sequoia:     "74e264e24f5340dad451f650ec8f1059adbf92dfd823380d19376dbf7cba835b"
    sha256 arm64_linux:       "990a035d46e3c75f39241f3c337881bdf503b667bbe579f146ae8226f2f2a96d"
    sha256 x86_64_linux:      "9ece41125ec6387d28e93650200c6a0cd29595b6542b5910cda50b9874e22255"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "ceres-solver"
  depends_on "exiftool"
  depends_on "gflags"
  depends_on "glog"
  depends_on "lensfun"
  depends_on "openimageio"

  resource "rawtoaces-data" do
    url "https://github.com/AcademySoftwareFoundation/rawtoaces-data/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "d84051305009e5a154062f837f62d432bc69f7ad9e220f3a57a056ddc9b8911f"
  end

  deny_network_access!

  def install
    # Replace data path to homebrew one
    inreplace "src/rawtoaces_util/image_converter.cpp", "/usr/local/share", "#{HOMEBREW_PREFIX}/share" if OS.linux?

    args = %w[
      -DRTA_INSTALL_DATABASE=OFF
      -DRTA_BUILD_PYTHON_BINDINGS=OFF
      -DRTA_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("rawtoaces-data").stage do
      pkgshare.install "data"
    end
  end

  test do
    expected = "Spectral sensitivity data is available for the following cameras"
    assert_match expected, shell_output("#{bin}/rawtoaces --list-cameras")
  end
end
