class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "b65c1b432a9903f554516445588cbab796865a7058380fd7856835b081e0ec0e"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f4825a84b0bfd47d489f2693151a8d509eee1239a72566e5bd25d5855057a87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723ed0159837ce2094896d3c1b371621d86e2549d1d22c2b726e2608d85a10ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "688c38e60e5681f258db01fc517f5a71c779abd2a27347d89c4d6e2fc8eebacc"
    sha256 cellar: :any_skip_relocation, sonoma:        "155b9b78fbe90fdc95c06f7906964bfa199147a68209144385eb617855a484a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01c65a340ccd9b543790b2a1622215bb60373db394e56bc5f017244b61fb8eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e1cea89c1bdd0b55266f0352a2adfab6361bf79285f5ef6bc9961b27a3de83"
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
