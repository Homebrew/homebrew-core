class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5231ce3bf8636d0aa98dc612e0288ca3083d55d2983ae666d98762a9af926709"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b08e1195a14b1b1e779db64f0a105f718cd8e03f33f982a5a9646d003e35e4ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a022e4c99baae0d3ed3027b1009d8dfbb19fa3253a4dcb33ffc8e8316ec578f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41371d12d68282c5938d489f34110becf71c794dd46d8e6f3dc6c9a7ee7e2df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1624af90bb13f2fbe21e1e7243832dfe2ff7cb2b7555d26493cd23e34778bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdd3fa6bda56ecb3f564ec0205b44f0a1d3fcb47defcd362300f569b9e5a4058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329dcf751da295667160e8bcabeb549cc543589d7024a256c0e84b224e06bafd"
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
