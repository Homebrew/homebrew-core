class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.13.5.tar.gz"
  sha256 "496a7e0c75593ab05ba2d011d3dd69b5e2b7b49c07fc0c37fcfde6fad93eee00"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec8ab416a45049d0c01de32d7db7a4314c588f5c3253d97f3c613c47ed364a4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37812b0f4568c51cbe83b7baca6909160e61b5e07e6da918436148bb2b323c00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4adcd90032cf93faa60ad309eca802f1c65ed5ae88efa011b0d5d1c231a39b81"
    sha256 cellar: :any_skip_relocation, sonoma:        "db03749dbfdd9729b4eaf33daf7ce249db48a08b95b179b248361cc2c3442f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61d8d27753a7dcaa1f53b7c7bb867efc6488a2316a81dad8986745da08bf5d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64ac04984cb16a1880f0dc0e84028c5e76ce1232aad885ac282de776604c3e81"
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
