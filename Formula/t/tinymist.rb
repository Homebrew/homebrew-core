class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.18.tar.gz"
  sha256 "92491d5bcd7ba2a5fe66c3c5e4c3728c2dce19a01a7f755010a905d31ccd0d04"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29ef8f24bffd154e1bd8040a665bfb21d8416c23c26a1163f765fa355220534b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4efc162b599eb2f51696f807f5a2371cee67e96b6c8ed245318acd8823ee4532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "388d5c3636b479c668ba9846bb8627c2b97e9c7e5c0501fa9933c5df18b517b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb39e056c3d72829695bbbf2b0644af2fd0af1e38c843b9e7cf4c727e18a104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9e00146f71009da8e4aa4caef8b5a3b5f33386ed640e1e1b6ac1b676f670b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5cebc8608a0ffe6f04e0609b2ee9849714b12173972865db979fc06c1c5d5d5"
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
