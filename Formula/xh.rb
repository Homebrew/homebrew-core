class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "31a944b1932fb785a191932944ff662a33ad99724cb5bc260acdaf821fb2e088"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c132e2860dc243963d76084a6239efaa4e9b6223fe66fb585829fb8a91025d5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d61902a6895bbeae9b9c2a3dcb8d1c8d4b06dfaebe4944489560c0b849b742d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "479a24e7e0e1da17ea1748bbbbd06ac80f6c676df39ed4267bfe50ab370bd4ca"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9120582a5726dd651a67ba937c8be974a60f06223c253d1d387ccda1b8c10d"
    sha256 cellar: :any_skip_relocation, monterey:       "bb41f5acdc9aa1803405415cd9899db8f463c854e4b4cca2a7a8b3a4fe0d25aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5c1ad60fca17aa9b6629cef945f00da342dd4d837c9e866ddaea5ac51e1b3b8"
    sha256 cellar: :any_skip_relocation, catalina:       "bfddbb660e997acea4a4185b75b00474e0cf30bbb1b3f7f6c287263f9ced8986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7459afd19edcd704db82dae3c3acef47df8236fa7d49865cb857abec4e37aa"
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
