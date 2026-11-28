class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "8ce0c4a86c2478a6f0d840952f5076d7ef242b76e944096c60be98b604269dc6"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    manifest_sha256 "ce0a8bd123a49ce696e111c1f2b9a26e1530555686b5eebb0238b0a4aeb66c83"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "865721414514758c317ce83bc37b43cf7e1f923ee360eef041446ad1f9011545"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c73064d3834e807399066ed78af61cde7f63b40409eda9a12bc84d6dbc3f83d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db31bd3653813f1e4b85a202c4f5eefcd42c23467dface0c6f83c75368158e48"
    sha256 cellar: :any,                 arm64_linux:       "2ffd22d862bb04a4338a58dc4f50761f7eb60c36679df6251dc441ef2d75eb2b"
    sha256 cellar: :any,                 x86_64_linux:      "a74990540167cc7fe66269d9aff5822365ad05d172bd251702343c0ff9b16495"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
