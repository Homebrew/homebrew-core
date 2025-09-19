class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2c11ca816f2b756be2730f86b0092920419f3dabc7a7173829ffd897d91888a1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5612309d34ac9c0a34ab536a0259a85039825959af74b5d1af40a38a79e78898"
    sha256 cellar: :any,                 arm64_sequoia:  "ef5601dccb812f86784c050ffc090b003b18dae3f1a8e38aa2994a43628f6079"
    sha256 cellar: :any,                 arm64_sonoma:   "d6f150dd66767e47837006f661a3c36ed7cd7ad21dfe76a7c1ba8aff1820a924"
    sha256 cellar: :any,                 arm64_ventura:  "2b2b2517cdf72b57face88cc1dbf6083bfd2a2b2271e857825bc7d012fd2bf43"
    sha256 cellar: :any,                 arm64_monterey: "27320ae60ea734c462bbfcd54fbee3444eed1de85b80315c1814850d043b229e"
    sha256 cellar: :any,                 sonoma:         "4f862af547f74f1859b5e717cd7368a6394b170db1f68ead37b23ddd5a1e1cfb"
    sha256 cellar: :any,                 ventura:        "b32e96ee1c8c76f0064509f450da12f54b2860c007a3651288e6fd2bb0d7cc0c"
    sha256 cellar: :any,                 monterey:       "1db13a28c85ccdd2ea30ca6f33b8a534b60610f513c3ae69ddc3d33e2ae8ab5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e42b03f16a1d0f0ccc344b0426a3ec779eeb3bf37dd9491847873b379693eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeef3daf639e9ed8491a9b7e0b11652809dd6d165410d9070fcf5f40f8883a85"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capstone"
  depends_on "freetype"

  on_macos do
    depends_on "glfw"
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "dbus"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "tbb"
    depends_on "wayland"
  end

  def install
    args = %w[CAPSTONE GLFW FREETYPE].map { |arg| "-DDOWNLOAD_#{arg}=OFF" }

    buildpath.each_child do |child|
      next unless child.directory?
      next unless (child/"CMakeLists.txt").exist?
      next if %w[python test].include?(child.basename.to_s)

      system "cmake", "-S", child, "-B", child/"build", *args, *std_cmake_args
      system "cmake", "--build", child/"build"
      bin.install child.glob("build/tracy-*").select(&:executable?)
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bin.install_symlink "tracy-profiler" => "tracy"
  end

  test do
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    port = free_port
    pid = spawn bin/"tracy", "-p", port.to_s
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
