class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.2.0.0",
      revision: "46a70d853267c40205a8cfea472056bd1aa7c04e"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "f28080c677864d601d55636193c4d18c5fed1160614143352bc11556e1acb8d9"
    sha256                               arm64_big_sur:  "0b4775a1d539b2ed26a95381e8f79b4b410a32e0ccbaf776c59dd8189792f87c"
    sha256                               monterey:       "a26c8df36a888e5350c22f6427dd3e625b73594fbea21cbd3b153b5998f080c0"
    sha256                               big_sur:        "ba5a56ba00f5c38638f95e922b244343ea6d25312e5aa23a9ee2210906e825c5"
    sha256                               catalina:       "bf5ffc292b0cb950c30a0fccb58dae4df82a7b2724522c9d796a2ace8c52cccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79a52bc3e1317b4de223e24e444267f3a96d19e9b6ef21c360b27c4ba3d2c8a2"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.9"

  on_linux do
    depends_on "gcc"
  end

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
