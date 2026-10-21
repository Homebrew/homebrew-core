class Tsuzuri < Formula
  desc "Block-based Markdown notebook for the terminal"
  homepage "https://github.com/jaisuriya-11/tsuzuri"
  url "https://github.com/jaisuriya-11/tsuzuri/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "1b1b9cf58e70a3e74d84eda68976213eaf1a2db8f43e08658f136057ab8bbe04"
  license "MIT"
  head "https://github.com/jaisuriya-11/tsuzuri.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d6c27208c44c06ea038cdc0941146e8a6bd46dd5c9f84f84c6b6d00613abca38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6c27208c44c06ea038cdc0941146e8a6bd46dd5c9f84f84c6b6d00613abca38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6c27208c44c06ea038cdc0941146e8a6bd46dd5c9f84f84c6b6d00613abca38"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03458125227b689f90d673a4a1b53018515b0017c351efa9a0c31982e43ad4f2"
    sha256 cellar: :any,                 x86_64_linux:      "220ebce58bce701d5629765272c4e8706b0fe8f2b314784dc1303cc854306999"
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
