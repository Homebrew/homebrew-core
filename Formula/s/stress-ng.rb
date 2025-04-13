class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.12.tar.gz"
  sha256 "20401a5a52a3b3b5d84fbdd561e4daf1076b0368a1ccbbbc8d41af2be6ea6f34"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56389382365576a45ff4da93af8636869fc3a0b473ce82d3e53355b72d3feeed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "904a4551969351dd6d42620c9425df4e10a477cf970c50661eefe35294f1c013"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1def857df76445e7b3ba0c657fea920d7cdf3ce839f454f7c2d744121c4fcdff"
    sha256 cellar: :any_skip_relocation, sonoma:        "251eec4ba9c8ba534c315b0cf919e2ae477c0c467faafdbbfb18bcdb2b8782ad"
    sha256 cellar: :any_skip_relocation, ventura:       "6cfe7d4572c6b1af31997c3811b4410c684ca931ca883b7c1ad6756d4096174d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08ce01f5d099329f763b961d4d31986f419b57bb902e28d14bd5b404d7ad596c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6154630c95e7905f6e54d6b736b967ae63b1bb0631b1239ade44717f9b219bba"
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
