class Xh < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.9.0.tar.gz"
  sha256 "b9a9386b552f527796f088b5d38effba8fd01c1dcb457cfd5bbfef23ec8c424f"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d06eba5db97dcccdf62f8753df895d37441122cdd12a55b80fbe0d79afdfa35"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae5c13b2cf57765612d55b6c0e0264b8065cfac0c078422ded3dfce3c724b760"
    sha256 cellar: :any_skip_relocation, catalina:      "0c26e9263fe4c5ec675533a665537a54af587fb9618711410a365adfa616f629"
    sha256 cellar: :any_skip_relocation, mojave:        "11cc085f5ac1b6bfc8d4516d7b49bbc647bc033fb2648801cacd79c0d1bdc768"
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
