class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "22654139ff2ee26b291976e5eeed7ba96990c624bec94446323022d65e0f8725"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "408269cc8961b1d187517b3a170be10d993de9d29c31ebb5551f9b8cf680bfd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e489a7a69df0d9eccf68bedda0090429b6ad4ba0b6187f210b07700ccc2574"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f33941aa0d20da8fdfedd50739dcc42345d83b9a0df119873cb9fd261a47b6"
    sha256 cellar: :any_skip_relocation, ventura:        "ab193c74a75a6ed15a5566fe7823cf66bdbca5535b73fefc3904151b2e4fe037"
    sha256 cellar: :any_skip_relocation, monterey:       "b416cb43c4e9eed3732ff02b80c00dcf373a601dcbc4b23e3fe54082d65917b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f749daaf8c880256a6b99b65540583d91d40cf0b99eba5a67ca45ba002e7c432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28605d693874e95ad1a72f435b109734e7a049a6688b2e6fed5833a3129e0932"
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
