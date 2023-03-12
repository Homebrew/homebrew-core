class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "9da168fe688cbc6e8fbe48d9fd8d99df6ab2561497fd431e320d66566e8cd93f"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d624a946594161010ba043ea2963660b0d3d52ddf239e5dcfd3821cdbc5e51e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07e119038a9df9483ec447873359e17084a5f4321fbc21dc07355e4c061a57f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ec64165779e701d06b3eeb989ee804ebe86f526518a6be994f12e4ca4700ecd"
    sha256 cellar: :any_skip_relocation, ventura:        "4eeb421f6bf44995a67a3b63934549fccb25fe48cbc155c3b7bf9dd7ea2d9874"
    sha256 cellar: :any_skip_relocation, monterey:       "daa9a8063c36f28dab52575731a59675b7dd6a619f56e0a4639af29945700c11"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2fc0f17bbda7218333f45d4e58c17503a3eb9e0a9b3a480aaf73c3275514b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5b78668981e39fa964a7d91c79d853ba960d5b96c565874929e94da93fd9953"
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
