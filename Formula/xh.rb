class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "6ea21c669e891fa6bcc8c8bdcf9f13db32c44bc1cdafd052d1ec34610db9a004"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "099f594778ab766b91b4af63bc6b893f04e4d17e0c484321c5677bb5f0347c6a"
    sha256 cellar: :any_skip_relocation, big_sur:       "66eced55e729455ef175160f28da594c8e24683b422b1f8bafe4c01bf758cf8b"
    sha256 cellar: :any_skip_relocation, catalina:      "3807b0b313200c4af1a1e8a9d035e4e242680ccebe769d1911f7ba66b8a8abfa"
    sha256 cellar: :any_skip_relocation, mojave:        "8abed39b63cd8578b04eefe2b0c70747ccd1bf23993619879e6b05ac368c367a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e10f518d398972a7e75b287dc19c54fa4541054e00a4b76d3b7f11cb79299ee"
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
