class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.29.6.tar.gz"
  sha256 "2bd6747c8f871d8db5c727b92358936de490e7b98aca9ed2ada39c99c7bcad8c"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5603baa7648d42b39b4e92824143ba60f2d6fc8d264f4bdceffa29bf88445cd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9725802bda50a82bad25b8cc369192133c82fce576cce8191897155b1be0eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e213ce35ddf378f390df7514844c0297440777220fd65fbcd1e861f35bad59b"
    sha256 cellar: :any_skip_relocation, ventura:        "bcc4d537c532e280804a3f5cf15938d914f521a63a52203946487da57f729088"
    sha256 cellar: :any_skip_relocation, monterey:       "0831e0c0950ce345dc2b5d38bf1dbd66a6952b1aa390a80fbad0b07d58064c22"
    sha256 cellar: :any_skip_relocation, big_sur:        "9167310e5cb62293364097b85a08a751c5c76274ecff0dda30c07a56ff68444a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfdc4e0eefed0b15142e2fc3b42263b343438838890bdec6e917617970dc4336"
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
