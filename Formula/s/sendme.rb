class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "2b4f0a361cf61852d915dbe2aac62c1d0108b510d36c204a128b77621bec72e3"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "deffd7e19f9f562d47795661c0aa9e58633f661e4bbf8c8d6a3b7db502b268b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9d98392f3b5a9dd275ddaae95e855964a144699a0060049e9221710a78b26f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f454e01b132cf096c33f2f62631295b536f997c7f319317437ba7e2009f0473"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9e1f90e76cc02a10b798accc25452ed4129b7fbbc88c5ad254f02542e6ebd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e503cc2d8d24a526c01e52b8735c9d48b9465edbb2e4ccc127ec602f6e5ae01e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e12efc7e94bfe59cc2d1c56ffd6553b3096e9690c0333917858989d69c6fe028"
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
