class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.6.tar.gz"
  sha256 "3ba8a14a9dd9494682f83bfbad9280cd9f43569e5890669a1bceab4287798055"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "692d3576035b1cb51cc43e0238f3ade7e16cd13124706341cade5903ece68ea1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d56c2ae106d3be5778236d67e911c4b95e76227b3df3b48335d9b7498a44b41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5abf05536640a325357775705f3d55f9e7c2653524ef6873e00ebaac6c3212a6"
    sha256 cellar: :any_skip_relocation, ventura:        "7df3efd4f0f177a64f7d9a8ee41a9f7b436a388c9bdded6790124b5e53b50778"
    sha256 cellar: :any_skip_relocation, monterey:       "d357527ec1c24075b325ca51ccc843248d6e6f5e4e4fe651d74d041391120be5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6c02367125883c6c8b788cb1e0773fd5ab3a3fb954b703e3a46db7261f2c3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a052f9b9387120f2218b5d166e42a3330ef07db6f6d109f4eb3b93ff9d005c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
