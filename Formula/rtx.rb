class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "b16ae68b3cf9fd0bc9f197510794a76b253ea2670a6c7300cbf354109aeb8dd4"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06246b0cb5c2c5b47407c2d65e9134ea6e7b72ebd53c126c16bdab0cbafe3617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9059c994da03bbeafc8140a155dd2c9485b3015af0549627b08eb3d694ef80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4aa47faaf332a013146a1ce96ca502d62cd6eb9ebf32b18ab9924e9badcf04c"
    sha256 cellar: :any_skip_relocation, ventura:        "dbc59d9fdf3a4afc5397d0032e29448b5b307b49117268c04bfb3fbbe3974855"
    sha256 cellar: :any_skip_relocation, monterey:       "a52ecf38d46cc26a3b291bfdb2139b74a15d1d63dbdd1d1ccdbabc77c7afc33c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bc010fd953154dc54cf2494fdee166d421a11287e664b3fb127d3e608e81ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1f138a3e66e1042d9e6a521c08f67c8de045b2c441f06efd3af42bd98376eaf"
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
