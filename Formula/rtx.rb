class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "cddf3b99bacec3a84f5b0b352eaf18de23fb72f9ce3cdf8c6e467826d422c819"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c22ae15b0f9b73a7cdf7b49b0e0cdd6609be1d2de90b682170312526bc2d151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c204f21a5bed0c52e8511d82917724dcda3a7b12acc98a57ce4a759fedbec62c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10bbd15284db40ae6e55c584d47c0a32b32c6a7b0f13d7212a61e183809fe53f"
    sha256 cellar: :any_skip_relocation, ventura:        "3d0229eba91dcf5e8c6572da64748a1351835c57e1342f131f0c753fe1ce2a28"
    sha256 cellar: :any_skip_relocation, monterey:       "859a86d64404c658f09a355863fa9f244590b6d1cf3e8d4debbdcf40524e4d9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "69cc50e86dacba6a73af84357598a590bdb048a4a6767cfeb01d617b6d5f8a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee9f6734680c36d35a1789c04bb1d3aea8b2eadce0ecf858e8b46ffbe93eb4a"
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
