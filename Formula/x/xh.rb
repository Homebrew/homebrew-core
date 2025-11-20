class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "6145f48cbefbb2bd1aa97ebcc8528d15ada1303e6e80fdd6a4637014f0f1df1c"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09bdf3126de1a518733e1469e53a377efb81845544b1d5f0d08e62f4d938b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b7f289a04a724821774f6530ac83519177605025c484584ebda45962bcc76d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7569e9f2fe3e014f148ea72b33e58e496e017e79f490497110d26c4b5018e18b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9cfede6039da74ace5b5753f5387128b9444644f7f0dac3126960f7958e9fa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c381b9c1a70f9140d746e9fb7b655c84066e0dec1184d1b619e54ece3827ee18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8690ff2328408ffe9a1a6fc5b0d91ec951d0b9ab4b47a3239aaf53bd93f8ce2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash" => "xh"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
