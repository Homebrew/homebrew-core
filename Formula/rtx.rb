class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "afee7e0f245e42405dfa1342c57eaaaf94ae06a138a63550a7c49976ebc8a159"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64eee995a7a04d73c28d91fa861cc78864f4c888fd8912b377ad569240a3b90b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2e4af1afb11796e00b1ec21e4e4aaec876fa51ecdd7ac93ff72a7064246b93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a5b744b7d4cfa4dd279c6724bf138571730e2e58f2082580cabc020e7ee52ba"
    sha256 cellar: :any_skip_relocation, ventura:        "6d2a130c902b65dcf9bad93f6040a1ca44222b9bdf76133e220a17365a6068a6"
    sha256 cellar: :any_skip_relocation, monterey:       "49a5245a9e71a2c46d84b6a7b89310c777ea1c9ba7c7fe05775fc643639960ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f9bd01d73c40bf184c7a9200e31ea5bce084a127dc0622cb047af9ebd6cfe3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb78cd3303cca4e90f435ebe59286c99c552091780d594e02554e0b03a6de11"
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
