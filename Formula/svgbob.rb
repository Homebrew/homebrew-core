class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.5.5.tar.gz"
  sha256 "e17859725c7f59b21a351f31664a7fd50e04b336a7438421775c44d852589470"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8e38c21372c66f2d3b9ef8f746e8268acf4b7b63713ca4794b7565e7334950e"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8931e1c0456a30ac41269816db47ff1db64689824b2a931b98fd880928b8764"
    sha256 cellar: :any_skip_relocation, catalina:      "999cdba86b39015604c276a9d58511f06a24ae08f3315dc8030ae9faaedf6d95"
    sha256 cellar: :any_skip_relocation, mojave:        "20e8ea8c15aa5749cdce3cf92b5f65e9584a0e55769fa66ae00e6bb897919436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0cfada182b8bf911a8e8aaa72b9f098811fd5b25117cffedb8e2db063a65ad5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "svgbob_cli")
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
