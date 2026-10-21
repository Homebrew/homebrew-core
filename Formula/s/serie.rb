class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "619f4ca2dc349ca421e36ac5a08e170b8701401d448fe97389010ac0b94f34de"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e94c149170c652ce375b0183c0e84c7649fe22443b175733b6a91acf7fc4832"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0da1b045d9630d7d5fa1260e591cb9485ee6f794e839c93ac3ca2bde97311935"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a1d925974ebd44a3ac4e69079e60e9c6c862a6ef90e439defaef8c111794354"
    sha256 cellar: :any,                 arm64_linux:       "29bab7b391f58ffc53e8e23beaebd1b0cd34ae6d78e9ef60d42ced763a0e4fda"
    sha256 cellar: :any,                 x86_64_linux:      "2f099d294d359c844de9c0826ce6c81c08338fd61ca2ab3cb582a0d6588f7d10"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/serie > #{output_log}")
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
