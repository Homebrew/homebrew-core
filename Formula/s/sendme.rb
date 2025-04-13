class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "d50c39cbe828947a5acf67f4c0d1db46017ff9e2fe2c8e77970dd515b1b024d7"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ab0de98e09c5b9915a44a75e441d0724b91342aabddae8839183c3fef5292c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4943b7174fcf8759dc6820853270f84da3272581f448973c0eed2f659b31f317"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8d1390110f8326011e78646117cbf07ef5df02abb0cb672e5b19fa5c0e65b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "902ae570d8182e3dab7c0e190e41349bbe240fee4fa4ee60c63510e9d285fd84"
    sha256 cellar: :any_skip_relocation, ventura:       "7f9e7975131baf76c40bf5c6f8af2b421d9058473f7a96201703ba702e5cb949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6829d388877534078f0be9e43c47de69f52d67c79af2ec4213a0e038babd3e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf6e22046177118629a060d27565012c52c5b3e98c955a9ba9b9853051693be"
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
