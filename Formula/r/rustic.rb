class Rustic < Formula
  desc "Fast, encrypted, and deduplicated backups powered by Rust"
  homepage "https://rustic.cli.rs"
  url "https://github.com/rustic-rs/rustic/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "d67cc86a0e589788c74bee8ab86fd9637b64253751c03fb35a16455457a4684b"
  license "Apache-2.0"
  head "https://github.com/rustic-rs/rustic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eacad6676220fc6be58d16b8a38e3faed8020c9d8637dd567b512e688da07c64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415c626d9d39383435902dbc801722c27dffc93ac94cea99c840ec19552b6309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e043c148db5232a4211b368ad57cf4ab4318fa157f476d77f7a1008575f26581"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5ad0c701e26123efdc66b833416b6f1f67347b806f08eeaa79955c68cf31d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f2bb0d7a5583ee865d167051b8fb90c77043f6ab8a30d3cb184ce55959fece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9571d4cf09ff19fc538db9b88a6c1218b44168f87e834d56d40424fa595336"
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
