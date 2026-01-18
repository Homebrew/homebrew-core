class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "a964e7bf09207bbed4e302b0c2592204005210ef3d25e0870ca74c4c078c3460"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc4441d58d87634d4302a4616664c1fedf5c54e121643bec893a7f8a694f844"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f9c012b461d55cc2cf8ea7104287725be418d4f6d00ae3a562738996dd3fe8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a6718322ac5dbc2e9ba782b1f78e61b36bad68b29906f06a5e8e765f33bbcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1d51830d618c0abac5d5bea675015263f65d727f7c2abbbff3e6a5df0cfaa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "775b604804413b68e77c0a741b7db44f4923a66122d10718d621520646681837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042d20f911af633852a52d287d74dad6055843e3c7bd3daf68efe20722cf233f"
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
