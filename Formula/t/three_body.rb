class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://github.com/rustq/3body-lang/releases/download/0.3.0-tap.2/3body-lang.tar.gz"
  sha256 "21a902b1437af5f586a9dcb8874250fc856229b66349f2fa556c53ea403315a7"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, ventura:        "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, monterey:       "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "", shell_output("#{bin}/3body").strip
  end
end
