class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.9.2.tar.gz"
  sha256 "45550c35754946ad94dfa44a60305610da38a56d2088a1daf037f2b6ad17e709"
  license "MIT"
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52766f7af99accd5f7434893265449408797462d56590c9d070d565ab148d4af"
    sha256 cellar: :any_skip_relocation, big_sur:       "e99beedf5e51165ed5ea32a42abcc5784e96771e9f5d8546b1b6cc38eb846c87"
    sha256 cellar: :any_skip_relocation, catalina:      "d164b5bfa49a9e7514f1c244590b0e2c7a77da976d5c89302f452390f212bfbb"
    sha256 cellar: :any_skip_relocation, mojave:        "7bc6fe2fddd3d44ff9b372818f17e9930fa660e99c169f2d090e3240f61c704d"
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
