class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.5.4.tar.gz"
  sha256 "9c6b71ae7d2578cc1129f716833251d95b88c147ed393f89ad36d3edec8e321b"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ed22da6dfde874e2e2b9ce2d09b73fc187305f172dbc51292e3857f278dd5c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce82936b22dba523554e1a8aeba55dd977d69cc0ad592ac5bf28d856689e0dfa"
    sha256 cellar: :any_skip_relocation, catalina:      "4ea928e1c3adb704ada860b4c147e4fc2f93ce98dbbef1d9908a193c0b9dfccd"
    sha256 cellar: :any_skip_relocation, mojave:        "f3cf2070512602d245dbbbe88b1f09e31cb6bcf1bc3810e543492dadfef4ce34"
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
