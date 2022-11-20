class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.7.tar.gz"
  sha256 "6f7a61dca076d7e2295e8ed5876cd5aff375b3f435ed03559b875f86a49a4a52"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7069ee90b4e75610f0cd521bcdfc257005eb265f63a376a00f6b8d904731abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d58f6a2a324e58304062a9dab476ed881beffc249e1086526cc121c18c36f4d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b937566a070a3a45a1fb2f251d10b82b082b39c44e1691c43f04cad423fa240"
    sha256 cellar: :any_skip_relocation, monterey:       "6efe06b3835e4a9e9d330a2cbbda2e994853231f81f2c906ba84dda64f2f235e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b3540039e243c64cfb3c1ee67355fa93c31e89ef3673414720239fd7f258672"
    sha256 cellar: :any_skip_relocation, catalina:       "3ab6faf174e991e452ead5bb511e2c9d3526c0079f23acf48378d9473033579a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776c0ccc59be86ca69e05272775d2bd1fe59a13dc15a17e4628bff07557c4918"
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
