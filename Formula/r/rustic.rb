class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "e8305efe543e68f75daec8ac5d7b7831a6ac5860f3dc37a8cfdf40ecf7d1e45f"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d5bbdd49649d561888d16a2a98ac3bb166047c1e72dc4c5d052c21ed03b8a40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5035c0a02bfd0373730ae6411a1b5fee539bd84276e4ea530fe6797e31d15633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b88bd386a0192ee706c5d835dc6397a38d434237d94ed935d5873e110889a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "620e3713af185e35e9182792903839b232bfe119f524b762e6ac1c3444a94f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6585de1c75d482af441145014458d4214f5a0424908bd686046d0a3b6805a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d83e8544d9e0c8d6702dea6fe062ac253f28cd1923d5a1d7283a7adfef4e009"
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
