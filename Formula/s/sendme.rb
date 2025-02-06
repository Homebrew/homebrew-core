class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "2ff85715d4c2540fde3d03471c829c057e7d5f21d26f08c5e6f0da5cfb29b166"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5293943a431656c7ddf01c8b142b196d6690b52277a0394130284a98c1ed726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356a572a821899662aad1810c895f8bd10361d9720b109d13a102332ab10bb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2ec0866ceb2a871c0f2060e14de95373c7115ae3c2ed447e8b3eeaa56fec104"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc59bdac9a47082d8299e5a34161c0eff808f39fa992a729445b90dcc18c33a"
    sha256 cellar: :any_skip_relocation, ventura:       "8bece2588f69a4464e021860af291f530f5071a5ecf663a8201afffccc4df516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d56872832fa2589f7982622546b40881beeb47ba1a847a15da0de3a8e9a750"
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
      sleep 2
      assert_match "imported file #{bin}/sendme", output_log.read
      assert_match "to get this data, use\nsendme receive", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
