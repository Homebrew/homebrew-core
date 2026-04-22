class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "91fd9496ddf27c573f742150a8966cb026240ba789e398a7b7ae7ca7f703b7b1"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3d3911175f7255ff09163996d38e983e3452f405b2378656109208f4abb7da3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9b2c17a6c5cddcd6d7bd1427ef736b1596cc45b60c10d720169e52fb39183a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d44083ee63af594a5f229e818f0a81973b59c7241fbe08ba87f0614d8ce1ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd9940d4ecdeb8d55162c392c68a289d7ab9eef575a72676b428bff3ca4c8417"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f83d8e7dd12c02674894f034bb44583bdb4efc5894058345ffc2fc9268e616bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dba0c6986599c02ddc6978a3cc033996eb9eddc42443e93df81e33a23d8d5347"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
