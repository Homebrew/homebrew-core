class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.9.0.tar.gz"
  sha256 "16f7e0ddb7ab52b0c8c29be0f5bdecae285ac7a88019220ba534357388ddefa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cddc0273ebbfaf94afc7c044195e3823ae60ad65237efc40191609d286e430f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fedce9f2ba1c00cb8af3fec744d9e728e235a0db091519079512949e538d47b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc78e1528101432c939165e16eca45ad3ebc2d1d156d0b1ce5b97d5edc77ffed"
    sha256 cellar: :any_skip_relocation, ventura:        "4edbcdcc0fc30e3803ff647d0e9cc6becbdce1028f3f36059e674ca7c15fcf79"
    sha256 cellar: :any_skip_relocation, monterey:       "733c527ca002033a06c35cde5f7505f813365adc77481bf595566902e7c5b54c"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb391dacd73ce6ebf4810ef5e3189a8a8f1cbb3449a7df470a54f42ff6caa345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc0b0d9507a857812057d4aafe43371d222b91c4ef5e950a930ece26ddc8604"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contrib/completions/zoxide.bash" => "zoxide"
    zsh_completion.install "contrib/completions/_zoxide"
    fish_completion.install "contrib/completions/zoxide.fish"
    share.install "man"
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
