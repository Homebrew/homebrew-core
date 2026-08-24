class Ratty < Formula
  desc "GPU-rendered terminal emulator with inline 3D graphics"
  homepage "https://ratty-term.org/"
  url "https://github.com/orhun/ratty/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2dd1c273c483d19fe2274075191d181ca33d67f280d52f07a8d6ea2bbe5296b7"
  license "MIT"
  head "https://github.com/orhun/ratty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7d6741d7d7a466f44f402084c5562b36a2147cd1f9e686c19a56cd4920c429d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f98033dd7ea0ee6dc61492bbafabb97908cf18f2ca1eeef85130a2237c5bd7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c841f5a7cc1fe0b72caa010c5bb354b8a7d2946ca838205ebeb69bdffd2d58d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff9445078998eb8c40621a83967c2260a6932dfaeec6e567330c7c3e076a578"
    sha256 cellar: :any,                 arm64_linux:   "a18b16c4a1b59dc4bce51d517edfaf53f71f43e9f2db2d674d43742a82b76215"
    sha256 cellar: :any,                 x86_64_linux:  "ca0af9c9b837ea078476f227cd78847e2595500997ed67387002c168c2f89916"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "fontconfig"
    depends_on "wayland"
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "config"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ratty --version")

    # No logs on Linux
    return if OS.linux?

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ratty", [:out, :err] => output_log.to_s
      sleep 1
      expected = Hardware::CPU.arm? ? "Apple Paravirtual device" : "Unable to find a GPU"
      assert_match expected, output_log.read
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
