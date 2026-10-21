class Ratty < Formula
  desc "GPU-rendered terminal emulator with inline 3D graphics"
  homepage "https://ratty-term.org/"
  url "https://github.com/orhun/ratty/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "84a5e38d6b811f158333f30e827621a8a70610306b0ab56ea14043cb306cfae9"
  license "MIT"
  head "https://github.com/orhun/ratty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a471ae15cef2c50cb3495fa9419046846f0f849c318907eb1ad488ecb71efc1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f4003bd686864dc30c3f83baf1357998ba86ffd4fc9d93570353e02c70e39b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a5dd6707591317814c459ec59e22c1afc1f9a1321cea6e383e8ef497f65d5a13"
    sha256 cellar: :any,                 arm64_linux:       "3258979947f6f8f6add3513371cf70347cccadb382bcad4c505b704f8866f9a4"
    sha256 cellar: :any,                 x86_64_linux:      "5d489af58a5f9fc11c131012e46bdec2c6b791bfd528f9b483be193d0b49f3dd"
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
