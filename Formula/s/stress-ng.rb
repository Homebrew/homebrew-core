class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.16.05.tar.gz"
  sha256 "ecb56e42a5ac6d94385de10ae8163a4fe50116d6b07e3ff61752d3854b630037"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "007d75e02d3650c3cc3a2fdd39ac8a49e6e7c551ebc0b380558dca04a3ff7aed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b80aa6d2fe70a5ead699b1968f3b8cbd40b639522394dce79e1d970fa6c960d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "063355294361f574ff0a21ac7477043df7ca614bbfc72fe230ce453d7335b063"
    sha256 cellar: :any_skip_relocation, ventura:        "51322d653d5ea8bcdecac3fdf772f0dc683ac56cfc50281cdce3a8b62fb61a33"
    sha256 cellar: :any_skip_relocation, monterey:       "b481f3cf1634868aa94c4ee79e0277b4d4228efd760e14121ed20802991ae784"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bd545bc0b9aece9ac9411d5a3163d233f36d6719a6bb0defed585ac0077568b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2473cb420287527b12f20f0bed3a5b14d77cc4daf95d3cbe767827fd423f052"
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
