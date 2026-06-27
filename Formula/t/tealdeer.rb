class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://tealdeer-rs.github.io/tealdeer/"
  url "https://github.com/tealdeer-rs/tealdeer/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "8b9ea7ef8dd594d6fb8b452733b0c883a68153cec266b23564ce185bdf22fcfa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/tealdeer-rs/tealdeer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321141551f399aa5609cb97feb5f2c8fdfb4bebcaa1e8477f4989bfd396f581b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b6c5618e65d4e910025fe8f878532ef3a99f05837b8058236a60aa4cfa8b59a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca99e9f1dd7c009b339e5a3ccfd005f2f6eab770f42f1dab2430d1d0d8c61156"
    sha256 cellar: :any_skip_relocation, sonoma:        "5230103bb0be717cd7c36e3f281ae9685c46c7d983a4afdc6f059e3afc3ea230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5984da1671a69eb623c7f5e47d2d8ffb3c6e7f96aecb13eaa25f3ffef0873da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06887fc14d9db667bcbd2bcf871fc4b7ab16d5f9755c1d1bb75afc52a90a3af9"
  end

  depends_on "rust" => :build

  conflicts_with "tlrc", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completion/bash_tealdeer" => "tldr"
    zsh_completion.install "completion/zsh_tealdeer" => "_tldr"
    fish_completion.install "completion/fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
