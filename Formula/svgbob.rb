class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.5.tar.gz"
  sha256 "afbf44bc536d34b974536b2d10059400a1e8e055d30e019520a2322a13a77c28"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2de0a6bcf8df742b05f729a2e73b9105748ed64ba20f97a02a50be12eef525a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2e074ccc877947e38115ef7f5e964d07532e84c004b3613cce137b2f9a7d919"
    sha256 cellar: :any_skip_relocation, monterey:       "c535a74a7afb59e3a1c333259d3dec359deee8618ce1e56649afdaa547f444ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "757448194ab944b65ff4db03746e5f74755cab16a81381f289c754f59aa2e253"
    sha256 cellar: :any_skip_relocation, catalina:       "c3dd296f61b00496c20d890712e9d8c1695f1f58b9d2906f0b2c90a4b0c71b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f87109973c709d85a1ad499f6dd3313516c221e3e0e3cc47b2e9522eb84385"
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
