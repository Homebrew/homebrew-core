class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "97e6fbcce30e04d3672453204aa1bb36e670d11e8b3c6df7046eacd2e5cdb7a4"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1a6de393ea1a8c3d6c2f527e5a3a9e5f4b6865c1a098e79d6ec3c1fa93f89fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c0147b92e2559571e477462c19d8ceaabecf8628ec82a215f894ebdb66a4246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57d3af63633bf48b019241d6a587a8764634ca22298764e456895d60ed72c61d"
    sha256 cellar: :any_skip_relocation, sonoma:        "be3e1e3957eee4859f1cb9350f46954fd2c666028828fb9bc0eb9d9b8432e6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "632b8038d9f6338b7bfc49c012700a01d6fdd61fdd842e71021914591f6222b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0628f4fb6a823deb7a5fe1b5631a4848fbba786e26c028d2418df52534aee2a"
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
