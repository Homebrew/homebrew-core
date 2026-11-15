class Sendme < Formula
  desc "Tool to send files and directories, based on iroh"
  homepage "https://iroh.computer/sendme"
  url "https://github.com/n0-computer/sendme/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "c06c3c250bca80c9bcac4650c8e4eb8db6e0b28261bacebac1df0c93b674e62a"
  license "MIT"
  head "https://github.com/n0-computer/sendme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21678494bdaf39fd55b9efb2ab077a5d918af3f1fcb5ad9067ba424d171c1859"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1536807fb47ddb8e2b9db05c7ba5554f0220a2428ee3e841c3c6f9549145bf3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0b857fd675f7ba1dda75ce99cec2a5c97970712d5783293c381c1e9ab383403"
    sha256 cellar: :any,                 arm64_linux:       "0871823b7cfe6bf51e424862101502f43e57e21718c8148a65fd44f5523bf9d7"
    sha256 cellar: :any,                 x86_64_linux:      "de29cfe60c2c32b54e06df95282057d807e65be70754657f2e48a9848169c077"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
