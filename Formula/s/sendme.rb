class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "92c5caa0f3ed3157a047cff7b3568e750764876a7958a36d2d8b865ff290992d"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4397599e5969b001425f9342264304144fa22b442b2fc4ebb457cba4aaa2387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75e3525335bfe957fb13470945e630ebdc14e734ce2b594caebc33a4982621e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5e79077a5287799aacd292a71079d880d62bc920df04009338f5b827e1bfcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8f7a3cc83247f6dee9a3fb78178ea5df97c5350775fe16b0b7f69febae10421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "368a4258b15f6345c0ea09ce9da86844340f38c64f72dcc204e398f7c8789bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c25cda1b0d48a054c515c60214e639877afaf2e1f3dd825baeac7f7b4c00f2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sendme --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"sendme", "send", bin/"sendme", [:out, :err] => output_log.to_s
      sleep 4
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
