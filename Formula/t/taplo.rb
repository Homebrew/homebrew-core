class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/0.9.3.tar.gz"
  sha256 "65510664071252541e66f603dc9aa04016c38d62299061419c95d3bffaa73125"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check releases instead of the Git
  # tags. Upstream maintains multiple products in this repo and the "latest"
  # release may be for another product, so we have to check multiple releases
  # to identify the correct version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "da36eb11dac5c0f350bb591c2b7ea79bdae70e404280a1264b416b68c49e9c16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f866b21d8b368f7a9514e55c10ef5ab404a3a2ddd5acb0f49654637560cacdc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ca79bc3aa55e7bf9e4b9e58ef6e60156765d9d8b02f0e289de1cf8496212ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "280ebeecf1512ff5d7fc178b4286fcf25425e63c9c43aad7504262444a897968"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c17cc64bb627ac1c19defc9ccc611c4827b69722bd9a906373384ef66bf60ef"
    sha256 cellar: :any_skip_relocation, ventura:        "ccda266bc89ec48f95c5b13f03d93cd1ebd46ad9f19fbbb6a7aa997b6d217e84"
    sha256 cellar: :any_skip_relocation, monterey:       "ce4fb0fa18cc75c449de18061f8f1a43b89628e317e0a8df0474721b37805d0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c69561fc93613afbb76a177f8341b90cdcee125f837f4930e71e1c8f9261d3a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be45406d8eace4a2e68edecbdc12343573bb1cc68da7caafe71c2218b38448e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "lsp", *std_cargo_args(path: "crates/taplo-cli")
  end

  test do
    test_file = testpath/"invalid.toml"
    (testpath/"invalid.toml").write <<~TOML
      # INVALID TOML DOC
      fruit = []

      [[fruit]] # Not allowed
    TOML

    output = shell_output("#{bin}/taplo lint #{test_file} 2>&1", 1)
    assert_match "expected array of tables", output

    assert_match version.to_s, shell_output("#{bin}/taplo --version")
  end
end
