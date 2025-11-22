class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.13.10.tar.gz"
  sha256 "e882cf587b922e81b1b6d1037e651f3c8e2d5624693855779917a60fc4b79a37"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ba6cf553d60c47ee73aee60a4913099f07832c259b4edb0e03527f44606154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dfbfc2bcd372baec87214a5ad11e98b1cc2dfd96fceab1793888346f6fc7d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a54148cc070e4a670ca09cc641ec812664602406b7227b4afe8889027ac251"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b833c9f355d4b9860353855a9b9a06fa1df7a24e758c705476370cebf3abc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191c41333b1e673e214bd67d971eb30809bd3df361d11b9fda375da778608901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d14d553647fd23ffbbe3b73730998b668872fa8c2d9bec4a90a4e3f29e6284"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end
