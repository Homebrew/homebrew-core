class Tuisky < Formula
  desc "TUI client for bluesky"
  homepage "https://github.com/sugyan/tuisky"
  url "https://github.com/sugyan/tuisky/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "b3db8969aa5152692f7178a17f51d694a2cc4e06bb8ff18e43b0f4c7a5d83fa8"
  license "MIT"
  head "https://github.com/sugyan/tuisky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8b87016d190d22809fa5ad344ba07bb51ab1415daa6c7a5383a975418758f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34cadf2a53e4ad9b8c7057064126b390dfe8ae0a9814b99535cbba1b2864ad94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d1a226400db44d379a0b0788652f6f6d7cd7f2a0e99d0e0d685c0ddbf74dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "2df26c17c036d72fd1eb39fc6d05b2b9a3735671e7a803a6c6b973d58dd17afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d923309cc7912539965ab0a69fb053de1d62f8f151db39467eb5188468e177d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55cf2a6eb4e49aeca71cd2b534c71159278a4c0c254075b58eb8cb7e7347f03b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    pkgetc.install "config/example.config.toml" => "config.toml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuisky --version")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"tuisky", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn bin/"tuisky", [:out, :err] => output_log.to_s
        r.winsize = [80, 130]
      end
      sleep 1
      assert_match "https://bsky.social", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
