class Ratty < Formula
  desc "GPU-rendered terminal emulator with inline 3D graphics"
  homepage "https://ratty-term.org/"
  url "https://github.com/orhun/ratty/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "78ac873053d680258dc049ad82f92d20b96ea7f3ba86f9fd45744ecc90befeaa"
  license "MIT"
  head "https://github.com/orhun/ratty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc044ef7854948b559bc91170b30b428ca3f9ae334ff775cf857d201b734de23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eee56e4ce94a7a031f6d176c35e0d0a38c025af918f4ad643e5beb02ed332e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cac112a0a6244f9911956fc00faf79cfe186677a0ec53f4a539f89fa9dd35ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "38845c357ae30cf3997510075806e5dc1e404f3bf2c65e1ebbd6ed0d64ad26c9"
    sha256 cellar: :any,                 arm64_linux:   "92a9629cfcbf3a00237c10c8474a18623f76016d8307947f0a02e45c32d0841c"
    sha256 cellar: :any,                 x86_64_linux:  "da69f066a2ab0e02473346ebf4324c434b96fb6179e2d813c111cbdb0c95cc03"
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
