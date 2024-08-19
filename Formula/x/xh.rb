class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.22.2.tar.gz"
  sha256 "32a6470ab705aba4c37fce9806202dcc0ed24f55e091e2f4bdf7583108a3da63"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b46d58846d7759fbe1c736006d0fe857b0492df34d6113a240d4d8cf5cd7a5a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "030bcc197bf059e6acf36ce83dd43ed355954db088bdc9a3f2c1b95abfe754d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d93303512119e48518cdd265c8ef8b3d98446c5c08cf6300b825f4dbcadfb8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec56cd579b6b9ffe387ee5bd885bc8185003772b2af8229bd8889f310faa257"
    sha256 cellar: :any_skip_relocation, ventura:        "6be7ce74ab53b52cf851c35b666d4fee4ac230344828896a79ae9e915a9434d5"
    sha256 cellar: :any_skip_relocation, monterey:       "450794b3b28a20add068a288a865b960cbdb20762f0f604ea673ba6520d42328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c42aca06e87462cf8ea08bf38da7e194cafc22797e7b3f43b536e876634195"
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
