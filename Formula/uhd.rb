class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.3.0.0",
      revision: "1f8fd3457dee48dc472446113a6998c2529adf59"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_ventura:  "ba03914755d8b08ae8e5f2f5bc66885e1fb5f2c25c7dd55f26963679308213c2"
    sha256                               arm64_monterey: "8dc8b3ec8055fe3e04123af3e6c8e446f3cf9fdea9b208ff65d2499c3470dd8f"
    sha256                               arm64_big_sur:  "9688a412638cf6dae758ed9ef88552b015add31a22bd75b020b465233997f319"
    sha256                               ventura:        "fec3be854d19fb52e8d3cef0d0ab078a9123d1e5216321224c3e1146002b640d"
    sha256                               monterey:       "70e9a62ae3703dc5c8e9ba42c6c62f7574bdbb6b9537eb12c40b1fd5899c4a67"
    sha256                               big_sur:        "b8ff52675faccce9b230c13982979eac0e486403d4b8d3121e1f9851b189f174"
    sha256                               catalina:       "9f250253e77e738a973a5cac00c97641b45dee9a3a38a135ca6389dc5a3c6dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcd60ad4829472bfd4d1e873789fd9f79ea32b70ada61ebe07c744a221fb648"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.10"

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/6d/f2/8ad2ec3d531c97c4071572a4104e00095300e278a7449511bee197ca22c9/Mako-1.2.2.tar.gz"
    sha256 "3724869b363ba630a272a5f89f68c070352137b8fd1757650017b7e06fda163f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    python = "python3.10"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python)

    resources.each do |r|
      r.stage do
        system python, *Language::Python.setup_install_args(libexec/"vendor", python)
      end
    end

    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
