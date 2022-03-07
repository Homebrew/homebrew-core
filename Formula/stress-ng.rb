class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.12.tar.gz"
  sha256 "16540d9cfa80d6a274fc0238d7251675ee38df6d5be805d14a67ce9efcb59ce9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a770f70d5cb4fe34cd9e802fbf096912ba7ad4b9615360109f93ff66254ee97d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02009f5667760e93a569086ee6d9e99141b9dfaf736df0da356aad9b4cc8756c"
    sha256 cellar: :any_skip_relocation, monterey:       "9b62617f6b22b642a7949cb6439427788c85c7d84269a6ffd6d976f1b5d7cee8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed8f5f01fc1d326f0bb93dcfc490463e0603d63aec94e789664479aeb91bfa58"
    sha256 cellar: :any_skip_relocation, catalina:       "b07d8be03e26ccc2b73d596e00dca2ebf00c0393cdbaa557133d31265b608ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b599502e47da03e594f8c58a8a9a4b6b8662e9cb8164d5894233a4f4c4ad82"
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
