class Ratty < Formula
  desc "GPU-rendered terminal emulator with inline 3D graphics"
  homepage "https://ratty-term.org/"
  url "https://github.com/orhun/ratty/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c6fb899b38445e79e0facc2d1a2884443f40296c47220fddd56d6489d3545c18"
  license "MIT"
  head "https://github.com/orhun/ratty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1403635c51402c660125ffbf9db95bdb50ab85b6d52e79dfcf63d4976d57a9df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c670896e149a3b5ff6385c7828d0377d6776d20c2ed761efd7a8e7b388e268a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5354db9f9437bea35f345592a5ddcb59f9eb40c11a34678b75ae2d869d1c55e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "064a9f5ad48cf6fb86fe2811f188dc2977402876682d2662f3de4fe46fe442db"
    sha256 cellar: :any,                 arm64_linux:   "042be503c70c270bee03dc34fa4493ff4145fed99046d3546fed7f98e4099616"
    sha256 cellar: :any,                 x86_64_linux:  "2c60b5f3c4479df1ea85c67ca002a7098b9a89473b72403d00ab439c8ba7ebe8"
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
      assert_match expected, output_log.read if OS.mac?
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
