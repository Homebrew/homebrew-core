class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "d6ec84977da567dd36a4c59d624dc1e2b1c77a21e2b0a10e463216120be8112d"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02f466f20327f97da1bebc62c62a0b2f7020a3df7a7a0891e698336f65df137f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f8f90ebb0129d20cb995fe3868ca7aea500d565c7a0962c76d04acdbfe1993"
    sha256 cellar: :any_skip_relocation, monterey:       "54fa4125eaed0fc2505885734ed1190ce119700d10816c7a7441223bc005c593"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce8a5ca446d00750009e1e70ca360484df6513dfc042525a28faad621047aefd"
    sha256 cellar: :any_skip_relocation, catalina:       "295445d00cf71e16e2cd11e9d022f380ff4b326e6cda43d08c5628a6a24d6164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb82dc0081f7d14f557b8b6b79a812ef400ea2b04874a3627a961dfde177890d"
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
