class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.10.0.0.tar.gz"
  sha256 "a9c66b52abcd586b513999f3a52345807b7551d01efac8c98eed813838be0297"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 2
  compatibility_version 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "02b42059af0149bc9345502d17d32cc06d7783fa425741cbc83a43398df9effb"
    sha256               arm64_sequoia: "b75a47663b765671797d214054a605ec5424c640a27daaaa8d3e0d288bf627ee"
    sha256               arm64_sonoma:  "fa590ca2bdf8f399ed1f4b638e4857231d4b28b624b306f65b9ac9dee7fb1ca0"
    sha256               sonoma:        "32e0a65f06fb469054d986b4e85e9f9baa784a539103c06087d1a6cbc39d1446"
    sha256               arm64_linux:   "6855b734b594977ffe14903494cc546420197d187b4ae46be42112b555f18379"
    sha256 cellar: :any, x86_64_linux:  "525fd3de49c9a5cfc01591626ed97a63896d3ce228e5b7dcc1959a66dbdcfe9d"
  end

  depends_on "cmake" => :build
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
  end
end
