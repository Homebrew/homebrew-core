class Xh < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/v0.8.0.tar.gz"
  sha256 "73525bc3973d60be48ce1e4ff3d948bd44fab54450064ff431a9f31acdf468d4"
  license "MIT"
  revision 1
  head "https://github.com/ducaale/xh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64964d749f996bc9db0257bad03eb87e3b8999b6b5a2e500443d705a9791145b"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa1a4544bb0d860c9346219e1130eb92c0fa76af6427a19934b4cbea1cb27789"
    sha256 cellar: :any_skip_relocation, catalina:      "a3e8759c45203faa82ccdca430c21cf1e27fa74f68ac820ffc5106cde321b137"
    sha256 cellar: :any_skip_relocation, mojave:        "da0cdf25012d6a602ba4e58d18a38703f22bc201c5f64ef9802f740a284c226d"
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
