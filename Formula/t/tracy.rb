class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b591ef2820c5575ccbf17e2e7a1dc1f6b9a2708f65bfd00f4ebefad2a1ccf830"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd1a741539f0c65f5871567157edc2aa4269703fb37079919c5043d1039c261a"
    sha256 cellar: :any,                 arm64_ventura:  "37ee1281141ecfb2a47315d41cfcf365e9faffc6166e1ac02f400a87bf0ad52c"
    sha256 cellar: :any,                 arm64_monterey: "da06ed8c0f859a1270ac08c4aef7f99691fa17cddbe03a8e1364cf4f3f7a2241"
    sha256 cellar: :any,                 sonoma:         "10d6d0b13a1387b809bd0298ac5103cfe901335167b87fc6740f3d7515c5288a"
    sha256 cellar: :any,                 ventura:        "70ff96b45cad523508fbff0f5e70c8577d6e4ad335399005e262effd89350ed5"
    sha256 cellar: :any,                 monterey:       "e8973f9aa0f62a989cfd4ea08893dd01aa463015b5d61e18d703263a085821f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ee49d32d243d29e7fe206afd278a496e38a6456329b1d7ab42cb35ed552e12"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "tbb"

  on_linux do
    depends_on "dbus"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  fails_with gcc: "5" # C++17

  def install
    %w[capture csvexport import-chrome update profiler].each do |f|
      system "cmake", "-S", f, "-B", "#{f}/build", *std_cmake_args
      system "cmake", "--build", "#{f}/build"
      if f == "profiler"
        bin.install "#{f}/build/tracy-#{f}" => "tracy"
      else
        bin.install "#{f}/build/tracy-#{f}" => "tracy-#{f}"
      end
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    pid = fork do
      exec bin/"tracy", "-p", port.to_s
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
