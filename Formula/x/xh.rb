class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "72f4d5e24165d8749433167e3ad3df8f26faafb250f1232acbe5192843e4157c"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca7f33ebb5ae75ae36c6ee857d13e3443c80866ebed637a4877425d1bbf43365"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdb86ba3e341b104c279f43bb8cdd3064a7cc6309d91d7b0aebaf959bb0a612e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f49669bb860a1e525a1ce0a16bde0e6022d156856f6c323ed396b6097b18b983"
    sha256 cellar: :any_skip_relocation, sonoma:         "e82c5da563ad4bf9b72e0f66322c165575a49ffdcfd4a62d8b9f213b47bf4d61"
    sha256 cellar: :any_skip_relocation, ventura:        "bb10a79627e171f77d32065191145c963c3213b54bd72074997cf0a533a4da3a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e2657ad7d9c2590e3f559068ab2663c1257606aaef9bfda77c7267d648589bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78230e8ce1cdb38eafe274848861c64bde8638a472011490f39665b256c0f87d"
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
