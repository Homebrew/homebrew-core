class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.20.00.tar.gz"
  sha256 "fe9e5161ac186c6ada22963251ff701fe3275fac2c5b87bdb59c4cab08aaeaae"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc087c615586c349b6a427ba17db998150a0c2ad940ae97d1b7f04426f73934b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb4260c60584236b843cd12bda45b88108f07e2efcb401685c9eeff36aa1925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2d5064b19bcfeb325bc1eb164b0ef73b208cc3a1108602a3789c68d40ff47b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f747b718251f9fe933ba28b30cff5ef162e4b8bfa037dd06975513a07084459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab572c9f1e43c8e5b4d23af03510dce11f7a71d14b5852705de9e5829338e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c930b6afdd321448b66d72982cec6411d74eeaec7f5f32acc99c2d94b0ad70"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

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
