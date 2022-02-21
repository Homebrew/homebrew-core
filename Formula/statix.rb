class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.4.tar.gz"
  sha256 "c237dc526ce24fcd10c21c216c22d663b1d71604e8d058a133a172551ffbbd9c"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66546795a65712864a205a99a58eb014a68d424ef11aaa5d662843a57bdaf0fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abdc9c2b84959fe0399ccb782b761191d2d638d5d2dc067304b9cec213061e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ccd32d54b80eebbc563eee6eb006fe73841c640c32cca96b87824a7fcd35e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4495f27d1a99d911d07bbf087b6839929c9789ab7e94bf2615a3e63eea0dd4c1"
    sha256 cellar: :any_skip_relocation, catalina:       "b6742ca992681d690c92501c39a37ff8dd549b1fd37aa3b9fbb2841df7d734b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caa49f9a843e1acbe002781328e50d0968012797db5aba1930026cf66bb16c71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "bin")
  end

  test do
    (testpath/"test.nix").write <<~EOS
      github:nerdypepper/statix
    EOS
    assert_match "Found unquoted URI expression", shell_output("#{bin}/statix check test.nix", 1)

    system bin/"statix", "fix", "test.nix"
    system bin/"statix", "check", "test.nix"

    assert_match version.to_s, shell_output("#{bin}/statix --version")
  end
end
