class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.10.0.0.tar.gz"
  sha256 "a9c66b52abcd586b513999f3a52345807b7551d01efac8c98eed813838be0297"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  compatibility_version 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "d2d8b22b36d74dcec53d69202d9a57c217bf15c7b8c81458c2faa24cb1001faa"
    sha256                               arm64_sequoia: "08806358c6bec7aede6b1dbdfbe96a937ce4d594ff6e7685382585a6d5570913"
    sha256                               arm64_sonoma:  "895ccb259bec8911f6c66910620745ebbc839df681d66710ee529043345e3bef"
    sha256                               sonoma:        "0d4396c1d2c519efe90d7b35240644ad6ba8c40b79df82e362cab22ac7b024cc"
    sha256                               arm64_linux:   "d065b6fc1491a5f15f00b1eeca9f76a16abbf2424e3d5ed2276c56e2d7114032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4641269e1dc2292c2ca2ae33c89f6460af58af2e6806f794aeddff0057a6244a"
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
    url "https://files.pythonhosted.org/packages/00/62/791b31e69ae182791ec67f04850f2f062716bbd205483d63a215f3e062d3/mako-1.3.12.tar.gz"
    sha256 "9f778e93289bd410bb35daadeb4fc66d95a746f0b75777b942088b7fd7af550a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  def python3
    "python3.14"
  end

  def install
    # Boost 1.89+ compatibility
    inreplace "host/cmake/Modules/UHDConfig.cmake.in", /\s+system\n/, ""

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
