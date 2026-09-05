class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "5dfdc9b055e39d4e645d778747b0e24a3395afaeb835603bfba8db9286a552cb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26737b65e5af51501b1c24be2a52b39471209d1e177ce808c2808e17278de13a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7741900260c8bd58632fa9735cc014f98bf4fe618b8ba106100d2878c9daaf87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c00756f4961983e62e594681e34728d0ce1f560bab73a5e0830619486efcd147"
    sha256 cellar: :any,                 arm64_linux:   "ff313a3fd58d1e3855512928739682fbaa2c940757f4275b3ecc274cc5d0d1cd"
    sha256 cellar: :any,                 x86_64_linux:  "aface4b71d60ff4af62bb3d59496ccce6f18ed197d2e57125379c78edd6fc163"
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
