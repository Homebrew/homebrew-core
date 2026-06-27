class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "f7a3bbcf4f6020aea6071b86bc9d20bdde2208f6dcbef019593e257baad4cca6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "050fa339085a5886869edba0642e8e313303249f855874372a2d7692affb7f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219a7fa2b25b8469f06825eae4854f3fb38249cf2aa565dbc2e57fb5647c543f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4628047565f6a00829f951314f40fe5db53d0df463973e47d2abd1fe1806cb51"
    sha256 cellar: :any_skip_relocation, sonoma:        "cced7d9f4b45ca46eccd8a5e418907083a0a8c7087bc197fa2ce93a8ca9d3b71"
    sha256 cellar: :any,                 arm64_linux:   "b500d814577acb4766cb49a4e255f908573ecba6a82bc3ac357fb722ceff777a"
    sha256 cellar: :any,                 x86_64_linux:  "41086ca7d6f446326d74f4e2be1419d25529a5e9214909037926e8df70dd28a2"
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
