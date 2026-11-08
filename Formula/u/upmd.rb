class Upmd < Formula
  desc "Run tasks and dependency-aware workflows from Markdown"
  homepage "https://github.com/rezigned/upmd"
  url "https://github.com/rezigned/upmd/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "dc662fc5fe25f6a0a4a7fb591d7271dcd67b2728b7acd74c5e2e549e744a6516"
  license "MIT"
  head "https://github.com/rezigned/upmd.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upmd --version")
    (testpath/"up.md").write <<~MARKDOWN
      # Offline task

      ```bash
      printf 'Homebrew task completed\\n'
      ```
    MARKDOWN
    output = shell_output("#{bin}/upmd --ci --all #{testpath}/up.md")
    assert_match "Homebrew task completed", output
  end
end
