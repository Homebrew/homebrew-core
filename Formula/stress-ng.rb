class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.08.tar.gz"
  sha256 "aca526f434bcf27fcf62da57f70458c7736899318b570bce0ee3da05a51cb84a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02f4268557a46e1b6d6d6e30fd96d15ad130d2a4399e42872bdcf5c5468aa755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08effd1cb3f7894e40faaf4413a6846a2c0e2e2a6e3224936f7e7cab7628ad66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89a088453234b9d79e969e51c79ad1513affab1ad8f6a4d2f42ccb60b6958242"
    sha256 cellar: :any_skip_relocation, ventura:        "486ca9df16bac40e40704998762e96738884ce44a03705c99e3c10203f9511cd"
    sha256 cellar: :any_skip_relocation, monterey:       "01c9a575ef418b9b54a0726b8dd953271d771942f1a708ee3644bc2ca24695b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "910717781af2fa6344f4a825ff6554269d67f4ded96974e1d1332af286ac8d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e0b57e7e3962308c432d6238fd7457c6720ef5a04f1808a9752bdfc8755f2e"
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
