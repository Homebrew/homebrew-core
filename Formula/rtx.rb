class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "c4a53c22337fdc2cfd23672eef29427828ef5c59e2bd8d03a9293309a3172336"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faef493c60b7dfa17cbad5bec8aedc02a6ce941866ad5dc4b704fddbd18b6268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ecc323a72f74d432ad1753a26d62897dad567091a345a8dbb62aec02f6b6c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ecc712654ae4d8787b8205b3dc8d3a6079731f0d2f2340fcc3ec19f3b18485"
    sha256 cellar: :any_skip_relocation, ventura:        "f741cf32b362707408cd9ee831cd980469258e44021dd0069562341227e3d20c"
    sha256 cellar: :any_skip_relocation, monterey:       "388e5bb74dfbff806c4f9fc932c01da964a8150da0798fe7178aa2118eea02e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8634ed246c0ff6a48555083a4a02af7d8420c41f157d31fadeaf65b37f36bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2459e6d9636521512295dd3e55f8f0af3a6b4fb37788ea65de452cc5f50cfb85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
