class Tsuzuri < Formula
  desc "Block-based Markdown notebook for the terminal"
  homepage "https://github.com/jaisuriya-11/tsuzuri"
  url "https://github.com/jaisuriya-11/tsuzuri/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9fb1a7ffe01471db44747db60591c8d6072c29639d6409213241bf13be2db796"
  license "MIT"
  head "https://github.com/jaisuriya-11/tsuzuri.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "302cb42d968393983986cf660964934f0ece39061e03c9d80c9751877be66b54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "302cb42d968393983986cf660964934f0ece39061e03c9d80c9751877be66b54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "302cb42d968393983986cf660964934f0ece39061e03c9d80c9751877be66b54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "177907e8e461eab6998dce412eb9d1d74481525048018e06c7aea12aa4acc8e5"
    sha256 cellar: :any,                 x86_64_linux:      "de88f2e963bd8be3c7427f62cf31a112acee45fe8c7a04f89ef2648f46955e19"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tsuzuri"
  end

  test do
    assert_match "tsuzuri #{version}", shell_output("#{bin}/tsuzuri --version")

    (testpath/"note.md").write <<~MARKDOWN
      # Homebrew

      A notebook with **bold text** and a list:

      - First item
      - Second item
    MARKDOWN
    system bin/"tsuzuri", "export", "note.md"
    pdf = (testpath/"note.pdf").binread
    assert_match(/\A%PDF-/, pdf)
    assert_match "/Type /Page", pdf
  end
end
