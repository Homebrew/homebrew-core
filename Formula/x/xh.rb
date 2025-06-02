class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "c5902052c66e20fd2c0b49db14edb027f54500b502108327e17260c64a42edee"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f01773b794e7e494e39bde6660a2b3cd31512a80f9b777eac95b2418ba60f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e60e82b1711213e1508bacdf28b5c94273b7f047e604f58b62412af0fe39bcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00197223af3b41c2712638150c4c34ec51d0b4b84ae8e98d5b14c21a5c7d343e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3cc91b5e35aa965a440ff19d3ea5818883e0f3f8db433f89cdb52b7e7b23db1"
    sha256 cellar: :any_skip_relocation, ventura:       "4cc9bdf9d3b4a9c9c52dfcf24ec48d6c499e8a238dfcd809181b71d3291460ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad81b5e4a15115c21808f2eb5cdf0d94f856c4c019e1b784366424731e034483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4c56e04dc8446c3d4c6990fe1db6bbe1cd59d1999dcedae04c2288d3e7ac48"
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
