class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.8.tar.gz"
  sha256 "682f3ca51d903a7267a0c6041fb12ccd2bc8402580f015f2a48594da278651d5"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32553c5b0c6db6ee02de82949e599f5b7fcfc6766ccfa11ebafa0631a768955e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf71e8dd6cc0d2dc8f1414db51f5714231add1f89f9d9fe96166c49ecd6892a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "301d841c89dda1e2468e17d133e8a2e6e383aef470da29c43bf93e9bd8ff32b1"
    sha256 cellar: :any_skip_relocation, ventura:        "38ad27ba5f3106bedea43c9dbead4c02c8f59c5f987ff259a815653a2fb3a1d4"
    sha256 cellar: :any_skip_relocation, monterey:       "1a86c5eebec2ca33562f578258f89a8aa7a4b4710062f1f4f21fad6d1bab41fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7efdee4154613e9008090b6d13c077b89c1f903471fe0bc5a4e498ab220447c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6da2379b2298552d361efcd7b7da7be367b6911fe2563eaacda1c13c3f92b411"
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
