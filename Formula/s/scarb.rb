class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "1eb59b27e7af487e133e7ba6be1f75781b95d6bae99f81cff31c56b1d91a3fdb"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a25c341548ec66fdd1c9ca3c1e23c9594b5e87429371b3718d452e188cb1d9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41bdaeaa2b3c7d77257f443e0fa1caf9b599bcf615c6dc391132a31e1831a31d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef7e2705abbb364c07a6c7381128891d31f49891c3cd0ceffd29c18f0823504d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d29e2266e993db709fe3300f8b2357e711b153314e3d473f7b7462d8aadb54bc"
    sha256 cellar: :any_skip_relocation, ventura:        "954b398978ccb540c3b420aec6825126350c114f1b9bdb04e228e08d00c7d2f2"
    sha256 cellar: :any_skip_relocation, monterey:       "c8e5951eb05d5862ed3d07c1fe8afd1eb54c93ff4c42888c2b7674cfb418f500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f322a4389e6222ca2e14e2eb8ce4f10ba23ec3a135232c0e34ca1d227cde477c"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system "#{bin}/scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath/"src/lib.cairo", :exist?
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb snforge-test-collector --version")
  end
end
