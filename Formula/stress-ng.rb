class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.06.tar.gz"
  sha256 "5b11df6495831e2e6a7eebf06aa83cc895cf013e08a9dc706ed1fdfba9a3052f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8b22c74c33bbb3f86780b6dbc536bf59f1214d94b68627742ed56a733c4ce35f"
    sha256 cellar: :any_skip_relocation, big_sur:       "916d48ebdea33e25c511126021fba2f310794abbc0374cab977368490ccc1e2b"
    sha256 cellar: :any_skip_relocation, catalina:      "0520586daa4837cd3c5b90b15da3f57d7d0b71bfd3b53b8d7934db9b02ea33ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b61db4e6fc4d5339d065732d0fd340f75587de5970c119cf1d421dd0b09e4e6"
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
