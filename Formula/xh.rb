class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "ed16781248d60a1f86d8da206440e9c761520bcd00917213dc6eb68fe357999e"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d61598252fc5fbb54df6eafebff6ca858d460357a45f6d1f6f6bae0551c11630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4be4b4127f5e092eb010635197b27e9a7578447f2f4cbca3a27262b5207fc059"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d761e673f263c3faecd46adced465de42066d766625e7f75d401189f9a17fba6"
    sha256 cellar: :any_skip_relocation, ventura:        "1f40065f6ff5b6df2c9738588f260ff1f831d772537102380b1963b71f5d66e5"
    sha256 cellar: :any_skip_relocation, monterey:       "2637f17856ec93fea48593d9b3b10edf5958c02bc4a52b0e25f443fe672e3c03"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf162b38e669261cc35ad5f160f8053b66d74f4ce92ff5c550d5b40aa2dd26e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed590304329cbd86904ff0ced04a11d7116e81287cebf975ea4b483dedc42b3b"
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
