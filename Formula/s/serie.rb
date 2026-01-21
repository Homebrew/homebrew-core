class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "c6e56699e6185a73fd4652f247844cecaad971e1956674b1339b3eff8aaaf422"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe044482e983db29fab1e3e4dbfe412c9e42be73abeac3e5069e20c924f921f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276b821f7faaa60ac8f6c7dd259eb04ae2e909aeedb2f1ba9983ac879b4a97e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edf64c854142144c58814e45d8ca63db0e6d444476584bb903906dca337cef9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b08f0d1dbb7daa929221ca5b399e0a2a6a4e7037ac67041f8fe4daae3ed16e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b469e52f19aadc5ac7ba674105d024c71357bc9c7e75a4d883345b643ce1cb44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f458c2a6ccc43afa94848e13e700734b555739e2263d67a6061eb6df0286cc5"
  end

  depends_on "rust" => :build

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
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
