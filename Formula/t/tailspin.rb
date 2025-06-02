class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/5.4.4.tar.gz"
  sha256 "5c7829245c1b02cc19e0c5a23222ab955dd0b36e8c11e135db4257e393a7c236"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12dd8c6a640bcbf84f4ba351978399a055c9b84521abc96de5f3514a7cf0e99c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d0884fa13813f1a516fc60f3550ec163ea25cdfc4d8005c7c8d38d26fc5955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15bcab094c86d4a6470fb0f1791f8484725961f4dcd0e2d5d50229fe65578218"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ab40356b2b2d8da2f1d98a8fde3cb7dfb9c2b39b2a26cad56fa5de1e010ee19"
    sha256 cellar: :any_skip_relocation, ventura:       "d5e93420e1c8be0c6e991882f309b5fa76c875d52ade5686709926b48f4967de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "786524577485d83a41abace9600a7a8b00ccfc5717dcefb83401614d045a53ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "102926218f5e5efd1bc1388ddec3fa0a3ced925acfc9c2d06eb4170eac84c44f"
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
