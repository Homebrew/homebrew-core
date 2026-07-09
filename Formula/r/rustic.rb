class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "abbafea18ea56f486a68f186bb139b0e8e8d002bb5cd897ed148cf7817a8ed73"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c85cee825a4f1486c33e4ca7de01c9ff9b89ec66f2abf78986c7c6cb2684e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9b26fc10e3b7bc2425d1dbcd2df02c6ac9167d4b49fd114434e6da341057e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17db5a9acff04bc714316ee302bd175d230e2a767df23b34ddaea163bb392414"
    sha256 cellar: :any_skip_relocation, sonoma:        "a437585b922b658783561520116e220222b3e8d9d85f053f2043c15bfe680163"
    sha256 cellar: :any,                 arm64_linux:   "d655f60857cbdd47b16e2642fc75bea0907d8ded9377d9a367db2b0be2f0d531"
    sha256 cellar: :any,                 x86_64_linux:  "f7d2dfda158d1eabf3f5fdaca502077ef2dd2732cc52367aaf969a5a66bfd96f"
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
