class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.10.tar.gz"
  sha256 "972b429f9eb0afbceabf7f3babab8599d8224b5d146e244c2cfe65129befb973"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8804d4eac8cb4f7349fb825d65dc0b6e7e8f805c7cd9b57921562b39d46d8f0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26d791f1cc820fb88e60d41681cc2f7b1bb77530ecf2431316dc2b6a27e861a3"
    sha256 cellar: :any_skip_relocation, monterey:       "11a24b1c59da25c4b4302d00e345c8c1505a4814c078628aa0813812598955c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d7407f00dfa08c9459d85965dea1477098e7128bd4fae15caa94ce30ec91aa4"
    sha256 cellar: :any_skip_relocation, catalina:       "fbe54a5f048cf759c40e1328bdbdd42f3b6bf238b111c30e7c5988d7dc4fd396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaac2cf54c6bc48eb15203ac9a3904229ca3efe6ad8e503768efbc527a1a552a"
  end

  depends_on macos: :sierra

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
