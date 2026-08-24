class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/7.0.0.tar.gz"
  sha256 "45fafd0b3b43de6490a1a4a86a071f0db3d2a8e3f260b50def131c6996a2930e"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94e3c4a8793b3144804d122b5b4c211b07a6c036d893d46a6761c99f312415a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b8df2e6cf97b132ff9cda60368110959d92ed86cc3993f4f7774bfda2134b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13e567abcfef5f14290aa78bfdfe9666f4e6fc789b8be3ad36055b57d29111f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7283ac0b56a8bf329e7729a45ba59bb1ebf0e0c865ab323e2c1fc85582e0db84"
    sha256 cellar: :any,                 arm64_linux:   "90873e84cd85f2e0199381c99086a5056cc5280ff082b290b6301d1a92bcb796"
    sha256 cellar: :any,                 x86_64_linux:  "b92ef64a5357eb98ee3588408cc5a77422a1ab8daf01ba0b678d127b405805f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/tspin.bash" => "tspin"
    fish_completion.install "completions/tspin.fish"
    zsh_completion.install "completions/tspin.zsh" => "_tspin"
    man1.install "man/tspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tspin --version")

    (testpath/"test.log").write("test\n")
    system bin/"tspin", "test.log"
  end
end
