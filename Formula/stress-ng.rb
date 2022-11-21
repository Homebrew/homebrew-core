class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.00.tar.gz"
  sha256 "cdb18c7dfcdeb0ff2d716c141341d1b2ca6051e4338cee3a555a65f26958c256"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ae77c4a61e026d2be548e901de8ae7e90df8cbcac6c1a2fbe6c1282fbceb9e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f10c0432f842479338ed5e7e9af70741ba35f0d5a0365316b87575907e944c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9f22005147bfd2713ea617796a22f55e87745689836f4441185f1403e4a28f2"
    sha256 cellar: :any_skip_relocation, ventura:        "940ce9269d2448cc1e5095ec2447734e53ebcb40756e79276bc38dbcc2252a12"
    sha256 cellar: :any_skip_relocation, monterey:       "249c9dbf99726e4a945ddeb50f21f6326b33b3f146ddf15ee76f5c71b6a0aafc"
    sha256 cellar: :any_skip_relocation, big_sur:        "53ff47ccdd940b27a042b0d307df40b81dfe9f531992043581851876994f9075"
    sha256 cellar: :any_skip_relocation, catalina:       "97bcddc85cfc249e527d64aa6a7e847cd9ce9f72b3f74c3bccaa8c4a09819fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657d836daf675489c8c419d961356cca4c614749025500b33aa81d3b9d310e02"
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
