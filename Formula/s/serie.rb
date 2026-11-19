class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://lusingander.github.io/serie/"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "ca6c8ae0799917ef19febc23f08f2495e05a69748536e51bfce67b0236644af9"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df7b34ea191dcc6f54ff02fafd0ab7998a6aecf46e85b070c8c9b9d86a62e846"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2997a424523d138202def9e6b1f0715d6d2deeeb75efe6534060e692b67993e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7880352386deaa08a52402d42317948aba47f3b0ca87f455356b235134746c17"
    sha256 cellar: :any,                 arm64_linux:       "8c492b2ff8c04c92b492f9cf5d9fb5b7db9a6ed1223ec1bdcf60a7483be902ac"
    sha256 cellar: :any,                 x86_64_linux:      "0e597780a41b25b82dbc237928cb235a46904ba77338f23a5e81ba968fb62b2d"
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
