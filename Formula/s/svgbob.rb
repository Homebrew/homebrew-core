class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/refs/tags/0.7.2.tar.gz"
  sha256 "a48c80bbbe1ca7575d1dc07a0a02b8d7116689dde0ffee7953f89865ae008357"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "556af648a5a4104f25b642e55e833c011a6f51662a30007dce2bb632171097dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a95291ecc34de16fee752808e98f2c6df881477516f2c8f2638ae0488f71a5f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c171c95df91d9bb63b93137bf71f94dbfd477c70ce2101d8bfae5b10170c79e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9863eea174639c29795fa62d6d9ce1dccc0c1450ece1e109f9e02cd604904781"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a7368fc3952f47ad022b81882fc6e0af9a799adc86520ad36df188134cfa741"
    sha256 cellar: :any_skip_relocation, sonoma:         "29868df7048921b54018b41c9d685b8ec19b4e68e0eff7cca853aee836146e2d"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d6834238b96fb5bc092e3f8327c78c60d35ac4af35426de02b9d474b607792"
    sha256 cellar: :any_skip_relocation, monterey:       "ea7c1a1c4f79f6f76207467968b6c037831fd727d069d3d026db9524d53fa20f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c78fce9cb0ad73241060c3bbe1af3da58ccaba4a27f3ca64d665d06372d1673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1adf826293db81cf51dc8f9c35ed68906b629e47e238ac429e35dec75a9d8578"
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
