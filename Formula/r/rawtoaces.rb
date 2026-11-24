class Rawtoaces < Formula
  desc "Utility for converting camera RAW image files to ACES"
  homepage "https://github.com/AcademySoftwareFoundation/rawtoaces"
  url "https://github.com/AcademySoftwareFoundation/rawtoaces/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6209eb1ddafb9696b25170e524e1e78704c30e1deaef63f4970b58177cc00bf3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "ec46f4d7f632968f9e08b9c533294ee591d65ba885e5cf435483aff0c08729c4"
    sha256 arm64_golden_gate: "7e316e2da424e6ed08afb2a4ad1e13a0cd93d373d3a545771d9b8f95f7275694"
    sha256 arm64_tahoe:       "9433b1b8566011dc7a129d29a56d736ff9d0717e74b5f7d9edadaf7104a36de2"
    sha256 arm64_sequoia:     "8c15f699526a6093aabedd68cda1548f2e1882bbe1f31577112149486c681ad5"
    sha256 arm64_linux:       "900138534badd9cba134127696d8ac104e21d6bb05b5694a3cbcff812e68ee8a"
    sha256 x86_64_linux:      "b19d54da14c239d4e2a1d85c063a3cd7367446dec7133c4541c30b5c80569f4c"
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

  on_sequoia :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "floating-point `std::from_chars` requires macOS 26 libc++"
    end
  end

  resource "rawtoaces-data" do
    url "https://github.com/AcademySoftwareFoundation/rawtoaces-data/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "d84051305009e5a154062f837f62d432bc69f7ad9e220f3a57a056ddc9b8911f"
  end

  deny_network_access!

  def install
    # Replace data path to homebrew one
    if OS.linux?
      inreplace "src/cpp/rawtoaces_util/image_converter.cpp", "/usr/local/share",
"#{HOMEBREW_PREFIX}/share"
    end

    if OS.mac? && MacOS.version <= :sequoia
      # Link LLVM's libc++ as the system one lacks floating-point `std::from_chars` before macOS 26
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
      ENV.append_to_cflags "-D_LIBCPP_DISABLE_AVAILABILITY"
    end

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
