class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "ea1796a66c22e2cd0232ee4d3e18cf95c7eb8608a465481023a6422f4720d2c3"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2c6e49451dd1599b68b81ada544cd484ea2519306f54d5e8e28ea05c26bb170"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507b2a4b5cd0388985a89da2cf6d26badb02255f238de4dceb28cefb7196dfa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcb28b49852a147bc8db3b56d49d278eac5852bddf34f808c3939bcbb39c7b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4921e5fca4381e1e636757ccfd268fa3e6dd39ef22a24273f2f04aca287381"
    sha256 cellar: :any,                 arm64_linux:   "77e484d7869bc792c7be902ba5005a676eddfc96a5b09bc430765d272f5af91f"
    sha256 cellar: :any,                 x86_64_linux:  "f0a49f595397102d4ac063dbfa71938e59428ebb95360cbca8e4bd88a80d757e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rustic", "completions")
  end

  test do
    mkdir testpath/"rustic_repo"
    ENV["RUSTIC_REPOSITORY"] = testpath/"rustic_repo"
    ENV["RUSTIC_PASSWORD"] = "test"

    (testpath/"testfile").write("test test test")

    system bin/"rustic", "init"
    system bin/"rustic", "backup", "testfile"

    system bin/"rustic", "restore", "latest:testfile", testpath/"testfile_restore"
    assert compare_file testpath/"testfile", testpath/"testfile_restore"
  end
end
