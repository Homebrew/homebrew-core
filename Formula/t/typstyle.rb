class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "987e019c16239d03e1ea38c3cb88bfeefa37b290886a912fa2e20e212bfaae2b"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1756cd8a712a7eb107d6ec479042e95c4a5c3723e593a65da1442367beae2d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3820ed00c2bd02778d8a3e9abf465de78869636f77ad71808adf897dee8869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51014b92077a1db199948de806cc258e83c1a1dbd31d0ac8db2541f983646ebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b82eaf217310a1991cca7ca24ab8fc8631f1fa5ca1472ee96416cda89478163e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac1d7deb8d99c0482a05c46b395bcdc0c082710e6470eb1a43d00afed201fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50eccc16ddd14702a1e56e2d1a01ebba6388f09495a9161b7b26c2d31d857a19"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
