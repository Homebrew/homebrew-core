class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.2.tar.gz"
  sha256 "bf4a545ad18b721b5d9d56947329fd1aab4179431a147a0fe445d43aebecf94a"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9c3733b17fd814e888c9cac06df9760cd76f9cb45e3cedc75d42385e987254b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f9676ab8effa5a091ea9fdce5e9afc438d0c35b9174580cfd1e090a765909a7"
    sha256 cellar: :any_skip_relocation, catalina:      "e7a40e48c48082fdc20009ca1ab4a916929053a450021fecbbcd1cca00eaf38d"
    sha256 cellar: :any_skip_relocation, mojave:        "cfe41298ae2497a7a5014388229d3ca9fe40888458ae3a191410a44eb768fcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98bd45da6e9c8ff5664d7f672ebde7fba711b01e40774ab0f8c9144673371824"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/cli")
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
