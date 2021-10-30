class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.06.tar.gz"
  sha256 "5b11df6495831e2e6a7eebf06aa83cc895cf013e08a9dc706ed1fdfba9a3052f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "484632f5ede25db3a241fd67545f88f357f141a99152c13ffff4cf531b706290"
    sha256 cellar: :any_skip_relocation, big_sur:       "92f16d015fd98a39b2fc4035134077cbebba49e05d307018336703e7b78ccca6"
    sha256 cellar: :any_skip_relocation, catalina:      "01ee57ddeb2d0134b8e01e895152f58e796cf547ad5e341baedea0aba58eee34"
    sha256 cellar: :any_skip_relocation, mojave:        "4c6ec1d023ead35abb1c037db5fbe601a5edb5a4f82095a274b8a2f182bf1570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef3c8d2739eb59d29c0beff8e8a0e0fcb1f1700aabb119e853f76a7a43f0da8"
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
