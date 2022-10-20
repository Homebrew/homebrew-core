class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.7.tar.gz"
  sha256 "6f7a61dca076d7e2295e8ed5876cd5aff375b3f435ed03559b875f86a49a4a52"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9487339e53bfa509c570f876622d604acd881bffe5dde975ae17bdb713760eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7c79046d2c85f0cb5b0a31307aa2098aa3250bd32b7ce8e9fe997414b912010"
    sha256 cellar: :any_skip_relocation, monterey:       "698a056b44d3e81740fc80577ecec9ef38455abc75beff788f99e2622cd7efa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b565c6fd1a6e0714fe34a581083e6ad57758b64e29c2fe7bc21352ad789a3661"
    sha256 cellar: :any_skip_relocation, catalina:       "7e097fec29cad170c5c5a23abac031445faadc106c6a27f27f0e14204dd5f7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8ba4e5e116f7738e5c2deaab13a98d19e259cad32c6476b283083366b32e1f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/svgbob_cli")
    # The cli tool was renamed (0.6.2 -> 0.6.3)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"svgbob_cli" => "svgbob"
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin/"svgbob", "ascii.txt", "-o", "out.svg"
    contents = (testpath/"out.svg").read
    assert_match %r{<text.*?>Hello</text>}, contents
    assert_match %r{<text.*?>Homebrew</text>}, contents
  end
end
