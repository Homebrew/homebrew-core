class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "c4850c82b125cb1c125ab701aff6964801812b95f1dc3c996d9ab01bd5a56edc"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e39e05e22b8b21690be71698ca4857da7f69a822c573fad906ce4899523297"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d1a77642f2cd432057f2b1db657b65d933d2eefc93d2c93c8a814e9434a451a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762d273a183b803cbf07a42aa01471a49d224549f9a529408d24b2e4b9ddf914"
    sha256 cellar: :any_skip_relocation, ventura:        "9150c7a1c7fae3615967ea2153414b340d44885f10410caf02f34ca64c8a61e3"
    sha256 cellar: :any_skip_relocation, monterey:       "60e8ebf15efd4bd1880450ac0b1dc0995a93cbe17efddfc1da35a286031d2a7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1298f47256fc88a66dc1f0c97529da07726a96c55323850b5ca7c416165d871c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61901be094a0ac437aad337658ed2fb0d19992d0d3a9215f2eb22bb271f19791"
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
