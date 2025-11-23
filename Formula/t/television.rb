class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.13.11.tar.gz"
  sha256 "a524e0cb07224794df7fda729a0aa90d77d7dfbb87a1a46a9b3b1a3c838532d5"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31de9fefcf1dc3418690d7f028917465c59e00dfaf11517969efcba78cf14971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "964262285a5c36379973eacde84f6a9232642eab690e5f7ef3f8577964141ed2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9f5eccfba9f792a038e796d91d413816624c14ad819d5dcfa14811e5d436182"
    sha256 cellar: :any_skip_relocation, sonoma:        "23c9e3501d8bcb3038dfd14c29fe5bbd103e49a5708b52c333f20eb0ac32db7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0826da232b23fe7fabde956b7412e1673c141e193924e74ee04b74798b58f079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540317d6a9033caca3b13fa3b943e6c8e2407023a687bfdcbccd0bd633e31df7"
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
