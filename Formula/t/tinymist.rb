class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.8.tar.gz"
  sha256 "46cab76c48dc27cefd5ea8160484ebc2ad5c428d5fddb65681d35cb55662fd90"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "942a7d34a731368e34c12060107838c5574f05c891232fccfa3b9edf1a94d016"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1cdc4cd71de8c4c4a7b60cd024fcecf9d562f6f2c585559fb2399620c57d61c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1ac0d9402e18f033db856d06535303e5ac8c6a04f1e364def43f7894fb6c757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0f461ef243e712e4d608c7210050ed7849913fd0054c11b668d6f391191dad23"
    sha256 cellar: :any,                 arm64_linux:       "a08ff00d6f3b5612e902922c19b3c7a629982deefb1f7fdf39a285c89754d53e"
    sha256 cellar: :any,                 x86_64_linux:      "dc3007be367ba006ef3270a247f0ec55255276b9ed5a776fb5447350ae475b57"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
    generate_completions_from_executable(bin/"tinymist", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"tinymist", "probe"

    (testpath/"test.typ").write("= Hello from tinymist\n")
    system bin/"tinymist", "compile", "test.typ", "test.pdf"

    assert_path_exists testpath/"test.pdf"
    assert_equal "%PDF-", (testpath/"test.pdf").binread(5)
  end
end
