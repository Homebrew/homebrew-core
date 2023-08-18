class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v2023.8.2.tar.gz"
  sha256 "beb69e87506d411a7ff75880a16911a5830fc9a5af6896da81568a7164f6cd7e"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17deac17effee551f77775e1cb9f3b0c5ca18c1661fcab74a9e7945f9cb5ac29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fae997e78bdfbd4ff3e9bb60183b26dc75e31958a3daa8b6d7fbaaa8239560"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f37d757d0471dba0a291f4c1adb933be35924b6ea8e1a85d027c3d5c48438c1"
    sha256 cellar: :any_skip_relocation, ventura:        "1ad9a6a2ef32dcf117754e05cc189bf2e5c75b1cbd4fe50911d18cb10b1c268a"
    sha256 cellar: :any_skip_relocation, monterey:       "a30e52654168a7e00c5cde1981c3592abbcf8af7c20f7bb4a3c5a1c1a23cfad2"
    sha256 cellar: :any_skip_relocation, big_sur:        "864ede6e8d4f19b53b6e2e4e5a2fed00ac6a64eb4486901f56e900af598eab7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ffee88a8acb147ceaaed81a74fb38a8051305cf703a7d29c2619f42afe34dfa"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

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
