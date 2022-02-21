class Statix < Formula
  desc "Lints and suggestions for the nix programming language"
  homepage "https://github.com/nerdypepper/statix"
  url "https://github.com/nerdypepper/statix/archive/v0.5.4.tar.gz"
  sha256 "c237dc526ce24fcd10c21c216c22d663b1d71604e8d058a133a172551ffbbd9c"
  license "MIT"
  head "https://github.com/nerdypepper/statix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7694283840360efe8f9395e20eaa9a03b1ea2fc2290a9b3eed0297bcc492c65e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfa50bbe6bbc726caa17290743421469cd3a0e4222f25ad1b03bac98fe6884f9"
    sha256 cellar: :any_skip_relocation, monterey:       "23dfe965149c4ade1a3c2d45fbeb85b2824bedceba1454b96f1b2bf830d19100"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fe82293d466ffc89da2c651ab7a0aa8db1082f7e67b6a262f812126f991252c"
    sha256 cellar: :any_skip_relocation, catalina:       "2af9fd448cf7c427c73a281a220da1010982e546403ab6cc48237107c9a2d79e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b14392df082b6e879fdc95f2fe4d47eef10c520968dd330fdf9865df61911847"
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
