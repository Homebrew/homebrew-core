class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.6.tar.gz"
  sha256 "f9698ee0600b6533ec7adf4fbe7c35389eb7bf6e72cb03d1d8b46e0e3b45916e"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2443d5067fd38e94c885f65d5204e8e3335966eea9ed3846d9351366a2e6260d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f3014ac10293974989cf739595cc4ee9b77582779b02a7b94cdd06184881e79"
    sha256 cellar: :any_skip_relocation, monterey:       "a4eb89193a763ae7bedf422cdce031a0292e8691021f4fbeb93515fe7913caf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f8984bce1a18ad210d9a2b591136a5e0a527aca11df4ac6ea4b598546f412f9"
    sha256 cellar: :any_skip_relocation, catalina:       "f1e0b4abfba05cf7b4a9f1f9741e1ff0f5a2bdc3306e02e1eb982a5e338df091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeaddd4070e0181a7cf669e562a49f4af3f6e75ab58858f7bbd4b58925bbf2ba"
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
