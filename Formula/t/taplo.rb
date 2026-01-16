class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/0.10.0.tar.gz"
  sha256 "c2f7b3234fc62000689a476b462784db4d1bb2be6edcc186654b211f691efaf8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2f39a73bc659d10bcc88514690a0830b9585e2411e5f3341e10a27e96ca7f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc34b4585bd26c0731a98223e7353e3c37e84693bbb828aae0c165eec4f6bd05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e89c3dd297d444b0dd22566341b14c8a1cafb92a5e3065401e5d6ba04481dba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec6957561bfe3ef9bc51acb50b47e5dd47798504521e1eb3f69028ead7f6fe42"
    sha256 cellar: :any_skip_relocation, sonoma:        "38160e4bd1c2389f0790068445938f0c223ca45c8e7ee91f0dcbe3bd82e6fd1b"
    sha256 cellar: :any_skip_relocation, ventura:       "e56649fe5573e848113e04f1addb70bc0862fd80d5e13a0f76ebccb1374b26d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f0c83c7dbb6db7edb0d040085531e82fc78f9f44c675a4a53078c3b265ec183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d598a281ccf6b7749d8e15dc2a506e471c06c6baa982969e712120704dc3899b"
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
