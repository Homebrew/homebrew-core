class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "c2de9f35ab2a516a9689ff18f5b62a55b73b93b66514bd09ba013d7957993cd7"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83e94a2d3f9c29911844e48b55def7807b42f11ca0be6a96fa5ec31bfa7c56e9"
    sha256 cellar: :any,                 arm64_monterey: "c1c03506306ce73ef85af7a40442eca87e4b4ce1b9aab09c64c2c38f23ecd992"
    sha256 cellar: :any,                 arm64_big_sur:  "390bf6bb1f080b20285929679304758a04140e52ce86956f57694b7835bfec78"
    sha256 cellar: :any,                 ventura:        "226dc07fc98a86cd44dc3e626257d238b8557fe7cc6b44f579a41ed59d91afce"
    sha256 cellar: :any,                 monterey:       "34ebd84f9ddeb63b81e9aad5b5ae40fd144290967789ba47cb279523ef5fd077"
    sha256 cellar: :any,                 big_sur:        "306585e77d83ad00b9160ffa2bd5b04fd83ca07d11a44080d113ad4bea82cc06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48d39610618ac1e3972d0db0afdacf0d305438358486f65b9c60b11e10bf763a"
  end

  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "tbb"

  on_linux do
    depends_on "dbus"
    depends_on "libxkbcommon"
  end

  fails_with gcc: "5" # C++17

  def install
    %w[capture csvexport import-chrome update].each do |f|
      system "make", "-C", "#{f}/build/unix", "release"
      bin.install "#{f}/build/unix/#{f}-release" => "tracy-#{f}"
    end

    system "make", "-C", "profiler/build/unix", "release"
    bin.install "profiler/build/unix/Tracy-release" => "tracy"
    system "make", "-C", "library/unix", "release"
    lib.install "library/unix/libtracy-release.so" => "libtracy.so"

    %w[client common tracy].each do |f|
      (include/"Tracy/#{f}").install Dir["public/#{f}/*.{h,hpp}"]
    end
  end

  test do
    port = free_port
    assert_match "Tracy Profiler #{version}", shell_output("#{bin}/tracy --help")

    pid = fork do
      exec "#{bin}/tracy", "-p", port.to_s
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
