class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "cb26f48325897946e7e6995d7617741586dfee0229ada1dfecb01e8ac90c4967"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "855e62b8c968742aa7c9a601d2e421559e9b78cb9f5ef3fbab6ca24fb456a89c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c336b3986e4d26df024f4f9e742a53141c3efd43484d1799de608ee37d8d4720"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51334b62cb18ee4a9dadfbce90575732d0b3537aadc63fa12e83cffa95808df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "16894672e81b26c149d26c84d226e9bd544a39c68d27bfe831f2e6353722b2e8"
    sha256 cellar: :any_skip_relocation, ventura:       "5f1b10b808848a9c702b2c2fd12ec10a28227e46f3824957e4e59b7bf0b9bbe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aa289175364ed60c1f3e6c37a8d363208698e158c5a9f0740cbbdeb5cb1569f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7369c9e3bf775382e418080ed6395f31c02bcdeb2a7ba0a086beca02fa4d23b"
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
