class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.5.5.tar.gz"
  sha256 "e17859725c7f59b21a351f31664a7fd50e04b336a7438421775c44d852589470"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a66b078159c77efc8fa7fa5c8a438fc2cf33a8f2cc1628ea0e988e5dbe87c278"
    sha256 cellar: :any_skip_relocation, big_sur:       "1229410e6279a5b12445d877f9176ae622ad0131339234df09a7864e855028aa"
    sha256 cellar: :any_skip_relocation, catalina:      "9c9fe19884dc7532c4de3fa64a46924953b0afe89861479e79e55b553bf690f1"
    sha256 cellar: :any_skip_relocation, mojave:        "79fa98122b1032707e00436415ab7e555a3900475632f650ac36496845513581"
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
