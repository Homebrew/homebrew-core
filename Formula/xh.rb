class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "ca89e8a9a230ff16cc0bba5bd7ebdceb986eac84638e15b4928d737b9ec12776"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed2e22467a2c24ef9d87122a5086e57dffd72456214508f6dc30dd2577d3043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19a45cf73e122ab38ccb44e24076a174600bbf1390d02bd64cae5663ef75ac53"
    sha256 cellar: :any_skip_relocation, monterey:       "6d7ebf15d31ef47e8013dcab65e320c2d76e211f596271451ef2d75c4d04df12"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b27925ccf7648036a90c0a5269dc03cdeded08ca4a066aaec0e71e1b6212c34"
    sha256 cellar: :any_skip_relocation, catalina:       "8d59bc6b194c00224c61e5f82bd1b759fd86e57f427ad317bfa893c67a5f73cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1852af6e619f4aef29c907573c084ccaf62ab2d27b202056532fd5ad7743434b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
