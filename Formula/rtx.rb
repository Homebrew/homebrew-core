class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.5.tar.gz"
  sha256 "09c2c450d7f700182f3503244dde45847d3ee32cae42b455d589afc9d76b9ae2"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb41eeb86ad6054a6a9de32cb08f672c37906902cee4b2770a7691291fd7f576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6586bad61161afac7ecd440650d9eb370d47025a5c6d8145c4304b92b766d15f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b4fdc6e8b96a02c2cec8910830cdd34fbcf4badb174307f62dece9a9269260c"
    sha256 cellar: :any_skip_relocation, ventura:        "89743b8738b50bcdbf401ddb27679082d50aeab225d57859e51ce3343dde4d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ef073f846d9db2a763bcdc77e6107af26fe9b9db14d115c851b6d84a1cf427ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d39aec2d13c28b5134fbf7ab84325946ea0a0678187ce2bf75fd44768f93ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8392f18f97ed6732e0cc8740ba1ba4e461032d712e1f051ad685bab6a54d0997"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
