class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.5.2.tar.gz"
  sha256 "86dfd9b8b0d548b75659257803618f493a126fdc7f2734cb8533ba240a1167e2"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d716a4f36c0963a3e2d80049e2ef0df949e77b7daa95ea045691e45435796a62"
    sha256 cellar: :any_skip_relocation, big_sur:       "60f1877b3d1dbdc68574f76080ea38ab2fa7f3801e4aaa7b90af14a659769e02"
    sha256 cellar: :any_skip_relocation, catalina:      "e51f40313155e91e0ac0202ba26141c2f88acadd941796c0f13d8794185788c5"
    sha256 cellar: :any_skip_relocation, mojave:        "a2c08f0f6d8ed080ded6ead2f0b09abf3dc66b67f0f108675c3a58d2624858b4"
  end

  depends_on "rust" => :build

  uses_from_macos "libiconv"

  def install
    cd "svgbob_cli" do
      system "cargo", "install", *std_cargo_args
    end
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
