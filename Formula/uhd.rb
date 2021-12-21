class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.1.0.5",
      revision: "6bd0be9cda5db97081e4f3ee3127c45eed21239c"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "189a96d00eafaf8bf4e91fad49eb7878a2825cb55c52313fbe9640def83d5906"
    sha256 arm64_big_sur:  "4d43cc1da5488afcb6e05db8df948bccf42dd6c1c96a081a762e9bc9d2372350"
    sha256 monterey:       "13c5c120c8574c980867c918772705ceb94ace679ce3cf69d1a4c3d10466555c"
    sha256 big_sur:        "04db68b8d74125c3a8b6cfa24877671755f6a6770dbee94adaa7cb9cf7646759"
    sha256 catalina:       "ded65b991342dd6e28ecf922cd3131f12fb106115a2986430092ad02a5213703"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.9"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/af/b6/42cd322ae555aa770d49e31b8c5c28a243ba1bbb57ad927e1a5f5b064811/Mako-1.1.6.tar.gz"
    sha256 "4e9e345a41924a954251b95b4b28e14a301145b544901332e658907a7464b6b2"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system Formula["python@3.9"].opt_bin/"python3",
             *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host/build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_TESTS=OFF"
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
