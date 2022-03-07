class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.13.12.tar.gz"
  sha256 "16540d9cfa80d6a274fc0238d7251675ee38df6d5be805d14a67ce9efcb59ce9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae18e1d842b41d92b356b4189debe63e2eb86c0922594f60b13b19e7ec9a1ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a243d1a986a0f12984984c3728809973074b24f4784b5499dc6b67f87a9495a"
    sha256 cellar: :any_skip_relocation, monterey:       "c7f5c336ed7410bd3eb1bf4d8e1e5db13adfb5bdd9711a77009b345e4b34041a"
    sha256 cellar: :any_skip_relocation, big_sur:        "40e64518ace7210afe958566bfc5540d2d13800b34a7e1ba826e5b6aef6a873a"
    sha256 cellar: :any_skip_relocation, catalina:       "b8dd4c426a357953ed8d8db07949b4405e38ab313b85a97b3f655a7fa3e8fa8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa0c41e8157971bc23f52a0e638e9e654ba92c0a619f3828096706e28d593a5"
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
