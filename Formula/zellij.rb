class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.36.0.tar.gz"
  sha256 "df64fa143c10f3c7c3e53befeb6ab3b8f08c220f3cf6331cfc6faa2aa779b6b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44a2448dbadbdab15ad990c37c5133573398b73854405838e2af6007f0164546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffe7de2ad98a455dc3ace221dc2217cf92e71e3315d412719bbf0e7fc1d54082"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a5ec61cf7a74dcb196ad391817d192ba4473afa1415bd870ddeb0e0a56da052"
    sha256 cellar: :any_skip_relocation, ventura:        "5e3694d8028150d38ba067498138d3ad77ee252edd873a9e7d1e8c38382fcb11"
    sha256 cellar: :any_skip_relocation, monterey:       "4bba42af4297fc45e55f4a63a96ccc569bbff28b763f25ed61285257a32bbcff"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8ced06594cc2766283ad12b1826276894f776716ba36a8c2d30f802844d64ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7dbace26a80ae067f10e7e8eda63330b5c25ee6c72e32dd80ebecbf1eece6dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
