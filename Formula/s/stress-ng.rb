class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.09.tar.gz"
  sha256 "0694f2c24eb5d839fe11f41adc2c0ea31bb7e9c1a53316fc251847d1d55f6344"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5f3fda42bad803182c4c9e1c38e23bb685abf282daea67a3c7d846e940cf75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f342c85e3df9f5dfda6142175216b3e9bf6c5422dbe676fb8d65442d6471da3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f962da4b7981b44d2d222782291bf912b051324feb35fc928d398dfbfaa36f55"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed71318ec05cbde511221e95895318fc45b99ab68cd60f9a88aef51e890ee58"
    sha256 cellar: :any_skip_relocation, ventura:       "598bef2ce4dc96003d353cca1d3eb50335f6dd40d764bf8e6258b331396b4387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a41dd80f3b0fabd632972830a5c4b3adf673d2104f1b270c20cf86c62736c727"
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
