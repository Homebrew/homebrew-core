class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.10.1.tar.gz"
  sha256 "fce43420c658e43a11b3cd17ee36549467d16504f96f4a84866a6ab6253ee6ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aab0871a893ddc8f1086d7790558c9be093513ff1d0121e0f6cab4c25b0b588" => :mojave
    sha256 "05c5b03b2ad84c8447327bca8d83a111d5c51f831e056b2a4614058b8bef67fd" => :high_sierra
    sha256 "dc48e24e06a1d7646dedc0712a85cafa1d14d4533addba3126ec65280d49f96e" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
