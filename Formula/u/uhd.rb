class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.7.0.0.tar.gz"
  sha256 "afe56842587ce72d6a57535a2b15c061905f0a039abcc9d79f0106f072a00d10"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "8af487212569ce117181b6bb884536580a701a581823cd615168e8fc5b1699e0"
    sha256                               arm64_sonoma:  "87477b72f2b117d10c580fdc2812e3e1c032309e4e2ce86836cc5250655ef03f"
    sha256                               arm64_ventura: "86904ebacfd828a291f1f205df0859de71bc412527270400c6eac5df69dfb43d"
    sha256                               sonoma:        "4a9799003cc7f032a630c857d17a6c970de02beb7f5778c143aa955df670b654"
    sha256                               ventura:       "43358e6612f828c025c1c7b2e6f00785546f33ab84d4b6c9bf7f4ea850d60947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8be6e51f1458a8f8ac8d85ab25e00e7d064fb6bbdc23c9abf62890a43cc45fc"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

  fails_with gcc: "5"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/67/03/fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddb/Mako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "cmake", "-S", "host", "-B", "build",
                    "-DENABLE_TESTS=OFF",
                    "-DUHD_VERSION=#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
