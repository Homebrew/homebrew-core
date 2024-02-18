class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  # The build system uses git to recover version information
  url "https://github.com/EttusResearch/uhd.git",
      tag:      "v4.6.0.0",
      revision: "50fa3baa2e11ea3b30d5a7e397558e9ae76d8b00"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  revision 1
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "92f1f1ff47699ab512a6158c0fe90fe423e515fdcc8b747deff7bb2cda90149e"
    sha256                               arm64_ventura:  "71fa408d611b35d62f354d2d8196679bad014c7884ec87ce7b864f620a1cc28f"
    sha256                               arm64_monterey: "e588c168d382f2339579c614a1838c645c05d194965e912320d75c44249d7b8f"
    sha256                               sonoma:         "cc32eff1fce1d2a0c2165fd4b1a7be2b3a8bbc585e65e26de6fa7a2c2db54763"
    sha256                               ventura:        "d9e7d7bb61e9978653285012ad1fd3a2e25c5c854245562c23b4345c1084e228"
    sha256                               monterey:       "7d268ccfdac3a005cd21af9502c770f3d88c6eaa2f3913abbd21e77c96adb090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feff805f30c5468050fc1b4ec9793a8f5301822ae3dd1c1daf8b59500ad9bc05"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-mako" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.12"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    system "cmake", "-S", "host", "-B", "host/build", "-DENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "host/build"
    system "cmake", "--install", "host/build"
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
