class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/refs/tags/0.7.4.tar.gz"
  sha256 "ec44991bcb34afe227135f3465b12baa6f438d0f7df7765676acca43372feeef"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21f5c5a35079bbf5a82a8790d309adf57fe258432f4589ddb15c8e04e4d6f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9c5be532bfecaa0f41ef33bdf6b684bf83c21b7c7025da6fd6946d7af6c44d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86f2e2f5ae44e6ef65eb9b2b3611b5ea4cf9abee9a958ea0f6f2ca661bd25c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8bd966634e4f81983c0dbc8a506b47f1286a1141b939f32de49c12529c3678c"
    sha256 cellar: :any_skip_relocation, ventura:       "5910ddb8d2a3bb2e21c36857120b2f95681350769308549d05a43969144adeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5348d7b6257d499805a07742691752a92be391b741a7391baffdbc306d351ccc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/svgbob_cli")
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
