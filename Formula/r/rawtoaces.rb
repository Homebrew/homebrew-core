class Rawtoaces < Formula
  desc "Utility for converting camera RAW image files to ACES"
  homepage "https://github.com/AcademySoftwareFoundation/rawtoaces"
  url "https://github.com/AcademySoftwareFoundation/rawtoaces/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "87daffd6036d533da948db63d6ac9f9b908385e4af99fd5ba8d063f3787dc5e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8f9ac522c5c84086babad728ede43e5b18065b5ff47ecf2a0f434573b6860f59"
    sha256 arm64_sequoia: "62cbbb6ff9579a9680af8ffdca0da1ff624f965efd3191ee74cfba83d1af2274"
    sha256 arm64_sonoma:  "6e37fa5bbd21c466b378154dcf6c7d62718dda2876c995315d04ff47be6f5d19"
    sha256 sonoma:        "898ff90587abaf64cd9f805c4cabb79571256cd39b291a35652e7a7fa0f15b39"
    sha256 arm64_linux:   "8f6e43d01779e2860e142a299efb31450ceef7761318ec0256ccb3de68b53e71"
    sha256 x86_64_linux:  "803dd222c4f433cd5aaa14851cd2da8f97ee9fc24e8ef8c8f850f130186545a8"
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
