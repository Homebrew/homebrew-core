class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.9.tar.gz"
  sha256 "93a91544e3d88f3bc4c405bad3dbc916ba951cdaadd5fcec1139af6fa56e6bfc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "137e3b97c5bdfffd8050052c3ebc6fc304f42b608fa4289dd5340f3a7e91430e"
    sha256 cellar: :any,                 arm64_monterey: "10ca60db0a37242410c9cd17daede06565de4315d20e320e2066f900e002cf61"
    sha256 cellar: :any,                 arm64_big_sur:  "b516cfd204375a68d77e649519411dd8787d1c56d7f07cdfb15bc0511dd9d15f"
    sha256 cellar: :any,                 ventura:        "34b88ea2a92540c0c47338ab504b1c25635e827ac64de2409f89c457e51503d8"
    sha256 cellar: :any,                 monterey:       "ba8954f3da81a5f916b2d5b687310924ca3f6c2ef604c66cb8f15192e32831a2"
    sha256 cellar: :any,                 big_sur:        "ad532e41bb74806c03d9fe4b99e72c6e3f0d8dcf429d04cb72ca5d83a87a20b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5188472f4de4924f6c531ae43f5c5c03c8c8f4234eb897ab7b1f47f8a5156d33"
  end

  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "tbb"

  on_linux do
    depends_on "dbus"
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
