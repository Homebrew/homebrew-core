class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "5c8e63b333e8d7f5ddf2099fe99b9e5521ce999413ad6283a680ae7b2da4695a"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "188fb8e2dd79c0d39b64b517058af1d66b0e63ee38a4bb2a5c74b04a5fa774ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2909091327cfbc1cacff19dc9a8a3e8da6fbae565e5eae9a9f2047ca415b6386"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f45533fbd7fbdb606c08ee675881be2b7ed572e754f1a140022dbbd3ed86f34"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ab4f14816f4950731f388ddac0b57b5f04c7fe992042636fd50f5c043a2383"
    sha256 cellar: :any_skip_relocation, monterey:       "1e32c44fccb0d3989a1e54dcd6e4bc5a2c876ef9a2a95d4afa3f2f448265c450"
    sha256 cellar: :any_skip_relocation, big_sur:        "da8b87d6f46326cd45c7c7926ce81ca0ee1c6b000f4118f9cd1791660018d269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e902fd06b77fa51618ac610983938c5eee67759e88ebaf7bd42a2865178aac8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
