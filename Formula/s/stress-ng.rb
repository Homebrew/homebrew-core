class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.10.tar.gz"
  sha256 "bb729844b5a3c8953e58ddb705dce8a62078ad75f0b6f49092f8027d9c699700"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e5d911125805f47e652edd1d05effb95b7ab1ba877f381e028c5bed8918755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b698dd30598d6fb76da743a622ea61d5ebf803e1aba165cb3e33460a31e938b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "675d9bea25e7bb3d2c86153baa4a00d5653404ca414762b2056501d7ba4e22be"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cca717547bab2a7452ec311850c79fbec88d217e445600935ab349beaa17a25"
    sha256 cellar: :any_skip_relocation, ventura:       "34a170fc0fc10703776f2dc2c56aad7228bdea735c02b9d34a79ceccd4fa1044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76049d085156ffbccd20204faac1c8c075af53ef568cc4d060579d457734da7"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
