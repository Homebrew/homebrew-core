class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://github.com/typst/typst/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "c07909e01a2a6941e52c9b616e48c209c755eed416d62bcf5583c37a4aca01a3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8df57b7abe7ad8d6b56456e80be509a47f2f0ab7ef265fb09a982d1fad05393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc0a76c1894c6eb2a73519f0df8b305e9d035eff4d3304818784d29d55ca2f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52305b0beac09e21dd31db3cdc5c844de6aaa79d119ae2abddbacc5658e9394"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaf429e12831dd8e576a109e14f8a957da69df2303bf21a3b71419e4dbcf9f8e"
    sha256 cellar: :any,                 arm64_linux:   "e14821b5092f4a52ba68159d38c12d8f6e12c0c3777461f74d629aac47eafe8a"
    sha256 cellar: :any,                 x86_64_linux:  "77dbbfcfa0dc142c62ef71b5ff777a99797fe563db67ed5ebfae23643b437cd1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")

    man1.install buildpath.glob("crates/typst-cli/artifacts/*.1")
    generate_completions_from_executable(bin/"typst", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_path_exists testpath/"Hello.pdf"

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
