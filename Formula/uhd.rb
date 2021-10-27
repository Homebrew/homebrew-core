class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.1.0.4",
      revision: "25d617cad7db69fa04699df5f93ece06b0a61199"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "70594fad59c2faea1b522830123a22765740fc2ced86e2619ee7c83e70784529"
    sha256 arm64_big_sur:  "4187dd90c18fa8709dc09087efc235f3fd21db604e082fce43c4d469aa789bc3"
    sha256 monterey:       "dd58c2cfb90bce1ebdfc1f6af3757da33082124217506569b1469d63de2ce8e9"
    sha256 big_sur:        "49bcc2c07aef5d7fa61702c3f52265b4d3557dba27a884784a1748c24ce2fafe"
    sha256 catalina:       "a44e180043a677bfacbba30f7fffb4ecdf42359672cd5336689e44b57934301b"
    sha256 mojave:         "30abc4dd1774370d969095ef735b05450785ac68b008cdde2e5d22fa634c65e6"
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
