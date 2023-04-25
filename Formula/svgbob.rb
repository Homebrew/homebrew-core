class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.7.1.tar.gz"
  sha256 "0c6692bd0abb45006efd1f093bc03ede9eef7cc715b706910190ebf7cfce5336"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19b7783560ea399d6ffe1f630bda6949708a3193cd0eabbd1ef2a3ef929480ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44f4d62107b37d0cdfdfb88ec0aa00defa7dd1e3b7ddb5c27dec254ba981096c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "668a536aa9cd8e36eb61f57db82ebbfb06efdccd7d6a4f38c9eaa0dcbc60f826"
    sha256 cellar: :any_skip_relocation, ventura:        "deb10cfc85f78d213fe82bfaa26dd95311dedd1fc8c772468c30097034438330"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6b88a72abfb4fe014bbdd9729c846057ebef0f6dff1ba50fa58261ddd6cebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b425fc9a372ebed4819bba296dedba1bfd72f39952da43b924b329506c57fc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37174d7e24d6d86ffd2c59f945a8d624c96ba14f6cbef70663c7bcd7f20e9ff"
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
