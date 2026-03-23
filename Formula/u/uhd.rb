class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.9.0.1.tar.gz"
  sha256 "0be26a139f23041c1fb6e9666d84cba839460e3c756057dc48dc067cc356a7bc"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "261b880284b0af7ee4fedeb3134ecd8650705ef53640091f057cf154be874d74"
    sha256                               arm64_sequoia: "9a1bf679d3a4cb9b77b1fdb8df6ed88f642f67fe2f44f739db1a9887733e6092"
    sha256                               arm64_sonoma:  "4118498bcec6d6fc7f58be464dba95c87f23539d762d5c11b51e303e3f747ca7"
    sha256                               sonoma:        "2111c2fd0c29de1e19977e5908c3be0bf4d6127e1168a3dca696e194fdba38c2"
    sha256                               arm64_linux:   "13a26ca46463c3c1e3656d25964804717fad9d64ab447f4df47dc36686acb58d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c13c228c82b67efe6e41031441f501faef05b9efcb7c9fc47baee7b43abc4a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.14"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    args = %W[
      -DENABLE_TESTS=OFF
      -DUHD_VERSION=#{version}
    ]
    system "cmake", "-S", "host", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
