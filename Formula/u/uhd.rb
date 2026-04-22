class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.9.0.1.tar.gz"
  sha256 "0be26a139f23041c1fb6e9666d84cba839460e3c756057dc48dc067cc356a7bc"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "c571d569fab53e1ca24a0b4b391bb63dd5f5c0d5d5f35c3e12de533c2fb18a27"
    sha256                               arm64_sequoia: "d6357d7c65b86a6060348e2b3e109b12627cd23cf95871365cc4176db29da3f2"
    sha256                               arm64_sonoma:  "90d76349a3e1ee02118419e5bc7608cf6022501dde60b989bfe3463a9dc0b22e"
    sha256                               sonoma:        "5cf536d223fcaed31cb4bcfbad8ca906e447054411c350d366ae507097a9838c"
    sha256                               arm64_linux:   "853774c5012b7ae12fff00b8aa0fc98471c5a3c1d728636b465230a23bc832e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b7d5afac326a53d266329f8205c6a5ea1c87efca8d64613b2c5e7fbc60936a3"
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

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/59/8a/805404d0c0b9f3d7a326475ca008db57aea9c5c9f2e1e39ed0faa335571c/mako-1.3.11.tar.gz"
    sha256 "071eb4ab4c5010443152255d77db7faa6ce5916f35226eb02dc34479b6858069"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
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
