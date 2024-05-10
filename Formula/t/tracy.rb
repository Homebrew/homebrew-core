class Tracy < Formula
  desc "Real-time, nanosecond resolution frame profiler"
  homepage "https://github.com/wolfpld/tracy"
  url "https://github.com/wolfpld/tracy/archive/refs/tags/v0.10.tar.gz"
  sha256 "a76017d928f3f2727540fb950edd3b736caa97b12dbb4e5edce66542cbea6600"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89d591c75f9dcf9cef53b6243b68d1a8b2d192c8f7a514000334bb8aa0a3c4e0"
    sha256 cellar: :any,                 arm64_ventura:  "8e755a116f50f11a23a0a4ced30bdd8d990ca9708a02e1dfdd06fd47dcdc4cb7"
    sha256 cellar: :any,                 arm64_monterey: "511c556958a4927e0f3d2ee1d8e03fc974a888a70fa436975fbdc2ac0b5002a1"
    sha256 cellar: :any,                 sonoma:         "9bfd9235a73dacb47faa65730acb7ebced534bb49f235a674ba089f4c27ddc17"
    sha256 cellar: :any,                 ventura:        "ba33f0fcd37ad5aad9adc864d0e29368ca93df88e7a0af1c002f0e2722df8359"
    sha256 cellar: :any,                 monterey:       "ef4ba91b47ab2c9f8533b22eb4d00377455831c4b9282d5eee22ef829c877d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab7235ba26d16cecb2c91532d0b4e48d29ef9550a08c2288dd56cbd5948501f"
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
