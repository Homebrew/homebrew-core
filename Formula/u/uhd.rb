class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.11.0.0.tar.gz"
  sha256 "1e53faec13ea2be9dd8f765956157d1434f41fa0a124fac8f7b2340f8445b026"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 4
  compatibility_version 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "a8b099ba24d6263ec9a86d477c007e61fb5f78483b5a2b7bcbc23c569e260869"
    sha256 arm64_golden_gate: "ba86b40452403a65bd8cff8a51b9a8f85db53667ca9e130427964e04bb12aa66"
    sha256 arm64_tahoe:       "7458b6953e7e61d98585fa7f91622b8bc36e1d6ff2a2677675d3dd7f9119fe5b"
    sha256 arm64_sequoia:     "dc0a90b47d2e9e1978f62aafd180afcd56c0f1fbcc34f9b22436a7ba25efa4f1"
    sha256 arm64_linux:       "f6a797898cc6ef375bb905ccc5d4b748ce798408211f905b7c1202f2388dcdbe"
    sha256 x86_64_linux:      "c9541c508db7b8e39c7b2b689598ecc220b0f54989c29347c059e56ac3a39e22"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "grpc"
  depends_on "libusb"
  depends_on "protobuf"
  depends_on "python@3.15"

  uses_from_macos "ncurses"

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  # Fix macOS library namespace, upstream PR ref, https://github.com/EttusResearch/uhd/pull/947
  patch do
    url "https://github.com/EttusResearch/uhd/commit/2dc0ecf9288a2556da762fd6693600f1572ecd2d.patch?full_index=1"
    sha256 "4e6bf9735767e245c87b57221c54e623cb76de3f9fa957787435b1ba20a2065c"
    type :unofficial
    resolves "https://github.com/EttusResearch/uhd/pull/947"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON
      -Dprotobuf_MODULE_COMPATIBLE=ON
      -DGRPC_CPP_PLUGIN=#{formula_opt_bin("grpc")}/grpc_cpp_plugin
      -DPYTHON_EXECUTABLE=#{venv.root}/bin/python
      -DENABLE_DOXYGEN=OFF
      -DENABLE_MANUAL=OFF
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <uhd/types/device_addr.hpp>

      int main() {
        uhd::device_addr_t address("type=b200,serial=1234");
        std::cout << address["type"] << ":" << address["serial"];
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-luhd", "-o", "test"
    assert_equal "b200:1234", shell_output("./test")
  end
end
