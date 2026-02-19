class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "760566567a1302db795a9657d1723bdf0b2a7edd111f8e2d1e1780d9cdbeaff7"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7abc3db58308ea8b25772a1ea732b27093936e726b03388206eb9166c9edbdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c86e250fc360851545f54e631c7b148d97e9a4fd2840122b5dcf95f9e5b49cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97cbcb3159e0b1c254f816d311783a0c925fe523fed5c0fbb9637d9c94fc435c"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3a375f6bc1e23da669a6986fb3a06458e2971dbd6a9c29bc9753c0f5a305eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d2a1a6f90652f121af9fb57ce68740d433a4fccd1b82456ef29463d34f395dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23ee5f6e07db910f57c29c0cf841efe5eb77c55cd9c714045f71e260baa189f4"
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
