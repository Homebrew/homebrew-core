class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.3.0.0",
      revision: "1f8fd3457dee48dc472446113a6998c2529adf59"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "0643876ee78155b69c5a3f74c20c9a250f39e149fd1ef686d6d262c3a8db7257"
    sha256 arm64_big_sur:  "ce05ba23746f4a6e6cf0032ba0e3a89bb0469c6c6978639cb315dc437ad4c58a"
    sha256 monterey:       "f1da72f1e2e80b77e7bed5e3de8e128f189a292612e343cd5d99695435baf2ba"
    sha256 big_sur:        "c880ad483752e7a28ed3b908f3c9dada4dfe382dda27d1655c123a80fa54b14f"
    sha256 catalina:       "a8a587efd44045da5a5f7c0c2a21c40c6084369902bd4c45db387f26f9a61904"
    sha256 x86_64_linux:   "45989f1da0a5e1980fd653cb014793d80666eaffbacdf4c82ecdb35c5a0cb61f"
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
