class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "73b96bd6b69690098bf31a22593a7d4b83e5143709b3c6adc923f00ccb9e2050"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49961261616ed82709e56f220450bcd06d447974ec1779de045f19ecd0668589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acfe1b48fc65a7d234d3b8db850b4e5a2a1122ab12fd73a3e6273200745857dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7b46a2f77b72a78f480b7c5c79b568234dd5fd17f6df12404c537ebecc45115"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8776e28af33a175f08f262a2c8dddf2c93d761d99c5da394c65994e2d28a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a99da1214ef271434f9284b369146cb59c9f918359f7daf5f4eca29e697ad68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd7a3b9cc59b0dc5b0f12a2812f27a95ae6ab1606fbefda80711757334483fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "scooter")
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
