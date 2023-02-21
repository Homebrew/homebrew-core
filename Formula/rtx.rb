class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "271337ff7b58a128688a7637367e82983675c33df2b5d855b49f25c25406b6d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36691e1c03426381939194eed5ee55b6442151c90a8473bc72318dd5f63cb321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c53ae56f5dd7c09f957e1cb7be51b14f2143ca23de50a6e2e385844efc2eaa26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a148ce0fa09f567523a24db88f3969a1e3d6039f6044a1de8649d1bab5d7840f"
    sha256 cellar: :any_skip_relocation, ventura:        "f8dee2e051959a4aba8bd17f348b44ecbcbcf615da80f4a9b08b7bc4eac91b06"
    sha256 cellar: :any_skip_relocation, monterey:       "433e3fb579ac69feee1ca614f07717d31e62882b75d124545698f01b467ac90d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a608d2522eec68b2e5c4fab3fe41cfafcf607c163ea6cb1738cf149a6d34b549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49db4d90ee1733956a70267cf43f859cbcfd1a7a3d952862638e422cfae1dced"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
