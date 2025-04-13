class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "80ecef9ca262b5564a951f41e11cf6125e5c4a62e66b87b071f6a333b6f40e5a"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "614e2f4004420fc73625a49c57d8ab2c6239d0475a631e8f2592692a3d585094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26dadc18c7a71191006efe3ddf251a3d1a15144447df81cc551bb9e7ac485f47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "851d029f70f421569a2e6ad39624c28ac71bd1969397efc5cb8e44b6598e86a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed62d206f4000099ffa4ebf28d30d6fd33801c224065a7e1598910f4bf3f4ea8"
    sha256 cellar: :any_skip_relocation, ventura:       "3c7acef4c3353d345b1b43395733feeed01f02f9fd481e3d7a57b2def080659c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75025becc1e529c9082f231aaa769333d67eeb8d9a9250a0e5e0aeebf89c06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24c7791c326b3f823d8777cb4ed9d041cf9b2a74ae1aac5167af69170d1695e5"
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
