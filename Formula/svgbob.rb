class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.5.tar.gz"
  sha256 "afbf44bc536d34b974536b2d10059400a1e8e055d30e019520a2322a13a77c28"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "141914b51693eed4891617c3a29f63bf4c7c7c7b93971e701c0848cf0e7db160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87ec203ac494f3e858017e21706a6499173906fa89f210c4deb7b9447c944e70"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc0296a5d68f04b898bcebe2273f8e6a4d846e3cf86f6b99d79dd9662e18c9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7daedafbd668c3c19ea77ca2852a1a49ef79d34b4d4986ce6c579a82a0a8828"
    sha256 cellar: :any_skip_relocation, catalina:       "56128d2d9104b0cfa06c2487bb2f6869023eb8136b6d5605dc2a205d2301c257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "536891cc740babb767a058c8421940ace007124dffa184100a88eb6ca9de5a41"
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
