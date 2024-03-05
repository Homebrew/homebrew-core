class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.06.tar.gz"
  sha256 "f81dc1ea7f2a821dab11e46cf3a3a893ad45299e51e6976041306871ddbc7f5d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "704e26145d2b9762de0c4009cccd2a76f549934dcb7fd2570b711472918f0bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03c35056b15ebbb55df78471e87c7786b29c4d5e1785808b1cab969c7449b443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4520e471e1629aade39af86a069660bd5fe00d6f7a21bcb25d2557b1668aef8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c3e7d1944701553b7c4c488739408a47c062b8f4a83101f66123a7b28d64c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "69868c98a2ed17d00011ba4d09adacdf2742fa009b09b7b9b567b1c5af243882"
    sha256 cellar: :any_skip_relocation, monterey:       "87edd5a9acd283d31679227a14ffbe70d9b151f022c1f4926f83e2f85f46e17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a7f6148676cec901923910e656e14a4354954bddd48975f97757e44f4b460e"
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
