class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.2.0.0",
      revision: "46a70d853267c40205a8cfea472056bd1aa7c04e"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 arm64_monterey: "efb94d7371798a8c8061d488a7ae8ccac97837cb894a411b5e0b2cafc88def9e"
    sha256 arm64_big_sur:  "41e8924b64b0ebb6ab16f5f2ab22a68cccee25cea271bea31d52f19c039d023b"
    sha256 monterey:       "52ea09e8fb25cefe281b0bf29062f728c5d45865dbe078dde350938d0998d376"
    sha256 big_sur:        "3fe0a796de18574d2ed3e6cee89233aa44f8a52b4214561f31ec854ed8ec48ba"
    sha256 catalina:       "459c43efefa0474c6bcbc22c987d8bfd540cdf7f71c14885af878f2600d18a4f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.9"

  fails_with gcc: "5"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/50/ec/1d687348f0954bda388bfd1330c158ba8d7dea4044fc160e74e080babdb9/Mako-1.2.0.tar.gz"
    sha256 "9a7c7e922b87db3686210cf49d5d767033a41d4010b284e747682c92bddd8b39"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3",
              *Language::Python.setup_install_args(libexec/"vendor")
      end
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
