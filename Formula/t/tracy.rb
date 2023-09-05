class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "c2de9f35ab2a516a9689ff18f5b62a55b73b93b66514bd09ba013d7957993cd7"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e0b1f660695b770f2ef198e4e7c3a64edcad50fdd5c992beed7250bb1327d4e3"
    sha256 cellar: :any,                 arm64_monterey: "34e51f9fc7008c8c6f9f328cd818a7e7903722c7ef7d0d72dfd27ab5ad8a0ce9"
    sha256 cellar: :any,                 arm64_big_sur:  "55aac4cf3f25fc366b1be4c3c29cafbc658e3de10cdeee75447e0995176498ce"
    sha256 cellar: :any,                 ventura:        "e6cada4786ff58d06ef5bd68b95a1112c7b9ac6f1742bb690c4c373e8c95aa29"
    sha256 cellar: :any,                 monterey:       "0f42dbfd5532724edcba0cce7e00cfc0facc8d935fc07ef852a7c77a2b877057"
    sha256 cellar: :any,                 big_sur:        "bb8583cd33abebeb2028620d15cc066467988e284c623d79ea7b342a915d1a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1158c9be06860d65840513ebd0189af488a59b5b52a63248bfff2e98570a2b65"
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
