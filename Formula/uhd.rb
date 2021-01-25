class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v4.0.0.0.tar.gz"
  sha256 "4f3513c43edf0178391ed5755266864532716b8b503bcfb9a983ae6256c51b14"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "6cc2856cd61dbc5757d003a75efc9f0a6a5bed1c559a9c21f5ac87a65b496126" => :big_sur
    sha256 "b63f3421f2bc1892731eaea65ae9ceb54f4f4d0cf4fea767939f4a1ff401265c" => :arm64_big_sur
    sha256 "000b6f7fd9126542c480b004ad6c0b7e85279d00ab5c3ff96bb45ba98acdf489" => :catalina
    sha256 "90f5734f4608e8a2c198bee12f4de067d7e5297d531c625bcfc4dbfcfd0fe7fe" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.9"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/72/89/402d2b4589e120ca76a6aed8fee906a0f5ae204b50e455edd36eda6e778d/Mako-1.1.3.tar.gz"
    sha256 "8195c8c1400ceb53496064314c6736719c6f25e7479cd24c77be3d9361cddc27"
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
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
