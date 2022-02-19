class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.1.0.5",
      revision: "6bd0be9cda5db97081e4f3ee3127c45eed21239c"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
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
    url "https://files.pythonhosted.org/packages/af/b6/42cd322ae555aa770d49e31b8c5c28a243ba1bbb57ad927e1a5f5b064811/Mako-1.1.6.tar.gz"
    sha256 "4e9e345a41924a954251b95b4b28e14a301145b544901332e658907a7464b6b2"
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
