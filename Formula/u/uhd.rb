class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 3
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  stable do
    url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.7.0.0.tar.gz"
    sha256 "afe56842587ce72d6a57535a2b15c061905f0a039abcc9d79f0106f072a00d10"

    # Backport support for Boost 1.87.0
    patch do
      url "https://github.com/EttusResearch/uhd/commit/2dc7b3e572830c71d49ee0648eef445e7f3abfd6.patch?full_index=1"
      sha256 "337b55e9323aef61274f52ff6c9d557fcae56b568dda029c3a70b33cccaaf636"
    end
    patch do
      url "https://github.com/EttusResearch/uhd/commit/adfe953d965e58b5931c1b1968899492c8087cf6.patch?full_index=1"
      sha256 "a9cc7e247a20157e2cbbf241315ef8fe53bdcf7db320a483b2466abcbd4efffe"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "4a05fe3cf7631907bef6a416e3a5e1b76ee7c9590e6c02a2194b66b7c5c79292"
    sha256                               arm64_sonoma:  "ea007011a24d72f1f3ff2d05b1e509d6a0b4bf79fc358117c1ce02714540ebb3"
    sha256                               arm64_ventura: "047350eee3e26cdb321be13ab062adb73d15690ccd6142456db1bc57c8296b4d"
    sha256                               sonoma:        "7f649d23d094b511b032788e8d67ea726c4ab394a9e30b2a8c42760aee1bf004"
    sha256                               ventura:       "aea0fe40b4c6a1a530ad5e57cf4296cdd82345b03730737852451401faea7a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e367b389872d8029334fad40c27e6567d17a3a2bab731c3f7a54c626af7cc617"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

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
