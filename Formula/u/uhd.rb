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
    sha256                               arm64_sonoma:   "0aa30be8f8741f6f033d4bdf9558499328b3f401d76da6ba5e46641a9ab22bdc"
    sha256                               arm64_ventura:  "bba91185c57f41b0341081ec2b0d11d1eec2d20a26ef5985a7d58afd92069ba7"
    sha256                               arm64_monterey: "908c5d7d364e45e2c76a3ac47194c7a00b012a187f7c3b06886165216f10a97d"
    sha256                               sonoma:         "a7f8deeaf539132936b14a357ad4c4cddbd017b87d4faee35278b7dbd58eccde"
    sha256                               ventura:        "53b7c7b837022b1097dfe6c17d55352a2fa97151f540101cdbe82664ecbca39c"
    sha256                               monterey:       "4669b02aa5c598fabbb0143f5011b5ead0dacc6756c9024a75abd6ba2125fb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d12aca3e8dae06f8fa880a920bbf6a5f1308ccc1abb405d3395fb0229ffb02"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.12"

  on_linux do
    depends_on "ncurses"
  end

  fails_with gcc: "5"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/67/03/fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddb/Mako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def python3
    "python3.12"
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
