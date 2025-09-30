class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/refs/tags/0.7.6.tar.gz"
  sha256 "d5b5fc4a04e9efc1cd313c84a8f843d8221718b34e8d3e135e97d44b81317bbf"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92d6dc8ffcafc044e0a67ad27ac513ced37300effd1056a7d077058cc7cc61d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a03f39e2238bd9ef7e474b580f9bdf820e755d2a6bc4569c2e43accef6f9eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b10e463d3bdf705337cfa3a8bf38bb369eb100403b5f0833ad2f53ee616a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dff76ac4bbd579cca1d3a11e37e55f8b68285e3f45dba68d23fc289f193d129e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6870e719346a6f048b08186f6832c6fa96e532f2198e42bc45d2c6039785492"
    sha256 cellar: :any_skip_relocation, ventura:       "36dcdfa05c440af6513da77701762c7d97aee573eac47dec79cb9e72605bba10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0200d4df7df55439d0ec87ab584b580ffa86caa3604ce55776ac17488d059a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ef6cc1b6c2841686f831901ce97230633658fe2f76b16958af86e49f6d7e82"
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
