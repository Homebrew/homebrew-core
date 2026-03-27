class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.14.tar.gz"
  sha256 "36d28b09cddc126e2b91c48a9c3b07e1c38f951f2e8a5546de8530b6e973c4bf"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10222ecb32d0f85816b1c9b3e415b08d2dc42698b4da59277adc17d7fffffecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7c137ca5f8a60a5696806f6715ccd02b6d3bbe3b036ebd5868d4cee97ec697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dada8919220c71e0b3fcf16f6f97b93aea860ee8babd46e6704c4294a77e9ba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ba0922b509be7026c72e04533672cd20ac5a38db0a83350b8ce7aa836d4f951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e34cf80c910f8a525eba16745b46e4ffc92836ec9447bab0a0d6e0dc9ab726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8936d05db224c331df16fd97cc26b17534f42bf69b8da6b61b55351760963ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
  end

  test do
    system bin/"tinymist", "probe"

    (testpath/"test.typ").write("= Hello from tinymist\n")
    system bin/"tinymist", "compile", "test.typ", "test.pdf"

    assert_path_exists testpath/"test.pdf"
    assert_equal "%PDF-", (testpath/"test.pdf").binread(5)
  end
end
