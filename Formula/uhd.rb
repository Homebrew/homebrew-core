class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.1.0.3",
      revision: "01575510f173015f83c1e1f82e7f406730b99f1c"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "f50bda6bbc78bd1756550f62411af5d2783c5772e91999f3fe4e94a3ec128af7"
    sha256 big_sur:       "7079eb90412fcec0523463e0292030f5ac25187e6359d96a0daf980367161678"
    sha256 catalina:      "318b27f24f20e4f1c040261dd424c78ae82222bf0930538b7236bb48d5fb90e1"
    sha256 mojave:        "b5a2ed217e2dd29f893049eaf3b9824222cabd7c8952008be724da939982b537"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.9"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/d1/42/ff293411e980debfc647be9306d89840c8b82ea24571b014f1a35b2ad80f/Mako-1.1.5.tar.gz"
    sha256 "169fa52af22a91900d852e937400e79f535496191c63712e3b9fda5a9bed6fc3"
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
