class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-0.9.0.tar.gz"
  sha256 "7d292f52c2d97d9e9c447a725d6d4e59096fce10e2f72ec6b80387034c20ba35"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple products in this repo and the "latest"
  # release may be for another product, so we have to check multiple releases
  # to identify the correct version.
  livecheck do
    url :stable
    regex(/^release-taplo-cli[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62dbf06be7cd564a1150d320cd9108971f752941df5def80f5955c0483bda104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2632d7667439054b99c9c234df686470ed18a76faa4bd406a4762301ce7b8710"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "050f1e9a2bea07ab48b2935b4ea00e1627e6c1ea77d532451dc9f7d01deb3f3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "19716fc45124770d7484fe298006a5f2f84e4d551e43409e5d5ab2f0b116bcf3"
    sha256 cellar: :any_skip_relocation, ventura:        "585c5c8109695af912b4f5ddc9459ad29c816b1c933d427278dec633e507d67c"
    sha256 cellar: :any_skip_relocation, monterey:       "05468f90d436ce19a8b3ab3ae4322d56565f14038f1b2487d860ca7a47fd3da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71d04b0eeb619bdc4007e1429162d7d1289ea338b642867450a1505dcfc49f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "lsp", *std_cargo_args(path: "crates/taplo-cli")
  end

  test do
    test_file = testpath/"invalid.toml"
    (testpath/"invalid.toml").write <<~EOS
      # INVALID TOML DOC
      fruit = []

      [[fruit]] # Not allowed
    EOS

    output = shell_output("#{bin}/taplo lint #{test_file} 2>&1", 1)
    assert_match "expected array of tables", output

    assert_match version.to_s, shell_output("#{bin}/taplo --version")
  end
end
