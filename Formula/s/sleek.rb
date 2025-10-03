class Sleek < Formula
  desc "CLI tool for formatting SQL"
  homepage "https://github.com/nrempel/sleek"
  url "https://github.com/nrempel/sleek/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fcb589fdc5ece8c050883ff0b56aec6bd25e2e4d6e77a1d52e870535d66fdf67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92c4d088b2e718baf4797d96f1c47730de545422b7549728198bf7a18eb04ce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7da065a9d2a8bc8f87ea6d2eb19cee0c60a358349761d9ea559ffb4c566f984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "777c706a4f2d429718d04629533688315ff6156d1689984d1e10702eb36bdaae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92fd6bdce1efc958d4df0bfb47b7d3b31fabb6cfe175bbb5b11f7e20e62d368a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4e2ac88f2fdb8c1418d82f19ba13ad142f7c111fa5e9e143212167a9c80b99f"
    sha256 cellar: :any_skip_relocation, ventura:       "38411eb332d28f569c81c6907a0df972efbd0e9abea5d1a86bb6c1bb3ab76834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0787c89db269a455792647f92c31b3dd0a8222ae400ce37ac22a8c11c694742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9e38b97cbd5cdcd3b1f8a2d77472dc4911e65ed205932606d1f56b752c21c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sleek --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * from foo WHERE bar = 'quux';
    SQL
    system bin/"sleek", testpath/"test.sql"
  end
end
