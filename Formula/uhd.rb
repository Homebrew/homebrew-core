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
    sha256 arm64_monterey: "1a10f56135f1aa9cad9cd8deb3d739dd71a7ec6104e2ed3c484fa604a7b51758"
    sha256 arm64_big_sur:  "a77fbf7cfcb51c33a7a3fffbeac1511633e1d8df42a71255aec055afefe874bb"
    sha256 monterey:       "1e006c2ede0dbbd0652e385981c7ffdf7fc3bab2a9f76113c33af46fc7f97c8f"
    sha256 big_sur:        "e28eb54ea3d5254ebb6559e1a0f354c9413def8eed2f0431797b0a9adf21ed05"
    sha256 catalina:       "8491bbbb396b96574c78d6412d429c98be07ffc68920cd1353558bb82280dcf3"
    sha256 x86_64_linux:   "48454addb60b428ee63e144a8de36cb6ec44902a47fe4372b82017058740e50e"
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
