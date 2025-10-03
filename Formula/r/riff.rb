class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.4.1.tar.gz"
  sha256 "d209e5b5a68907382cc91061d2e0570789293214b402c1b344008760fe298302"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc2e58cdc4df32bd9ec93ce6401c1b2220617b72d6edaee7dc9dad12b770a749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a16798ac94f4dfe2322434f54f74cbcf07be8bdd520668284be3c085fae711e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c7910d2bc376f3448d4ac298ee5e1d16e07cd81925aa4d1696a6098f685697"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d435ae34931245adfb5b50b4b48228cc9c60cefea982fe876c16e32a6352d132"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c3647c1be1e09312a0f914f11edc059bc84ba4acc7f52b309e240fe7edff782"
    sha256 cellar: :any_skip_relocation, ventura:       "2cf86ec4f6f55bf58259b5566b7a33036bd07223ba35476322486601cba4c096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76c797d5a30c323333f2867f198e01aa2297d2cb99f791175ad6a7463b0a7389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e625d6270edd222a6cc6b9d9c4ac02861ea65dcb269f18b6930e37be27f052"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
