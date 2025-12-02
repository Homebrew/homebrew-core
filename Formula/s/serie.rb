class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "bc7dd9317fc3b78097ec8305d0fc7a45170a6d7a2e3d9d8ffdeae49715acdbf2"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f6bbc8ba4fdae752fcf0475a01a88284186d17b6c1939237a18332103769465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c04afabb9a5a3a6be0b792cbcdc0142483c14ff4d6cfad8457b3c229602cc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6a977949e896545b8576f4a03c687d6f40866d75706e69d96a3a1e032981d5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "692f67f073e1b58f57c880dc6fc22000d8d203719b42ce6069ba8cfcbe0a839b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d87ec830ae8c1f2e6712e8620166796af1ec8ec7f8e45954efff2047e9b9cda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3af3866739d2dd2ca416862fd2f1e2b7a2d0bab5f4f064c34a31a75b004e3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
