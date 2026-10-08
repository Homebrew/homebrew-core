class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.11.0.0.tar.gz"
  sha256 "1e53faec13ea2be9dd8f765956157d1434f41fa0a124fac8f7b2340f8445b026"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  compatibility_version 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "b0ca37978a7ea6800cf252748dc91596b22a619ddc93b06a1512912500afea3c"
    sha256 arm64_tahoe:       "5d4ce264b8be392a4dbdfd6c85a924d8e22513bae2ae57f345ec708cc42a460b"
    sha256 arm64_sequoia:     "59df61d94f002bc45661de0b32540557eab7265ad1f0ee3e29f62a62b36f017b"
    sha256 arm64_linux:       "1d10142c19cfabfe6f63f595bdd1156e39659b4607bb2e341a5674bdb45d5654"
    sha256 x86_64_linux:      "396a4f3628c7a3acbbdde4d5224b084aa83a0896ce88eb26082a3e210a1e9b9b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "c-ares"
  depends_on "grpc"
  depends_on "libusb"
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "python@3.14"
  depends_on "re2"

  on_linux do
    depends_on "ncurses"
  end

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
