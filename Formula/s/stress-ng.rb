class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.06.tar.gz"
  sha256 "054953145d7de36725a54636ea68975bb9ada06b4769878d25e556fab5804513"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f94024f87fd6269aef25e9cd3c64935e7e772920910e979cf2f98024805e6012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57ad181a81a91b24da41ca8308704c6c8f496c5d55cf9e740c6406b57c4532a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a641c62233dafd1bacaec3be055ca0a294606ad5917ef574a8b99bc184860b68"
    sha256 cellar: :any_skip_relocation, sonoma:        "669e628143b420d719532cdb5346367e0c45eec243ccf263f6ec244ce2d19f31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed5e7de5ef4d98576ff470b2aa8ce87e14fe86276b8fab78952c7efa7af9aec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b25af3cb2250556da874d8b4bf979c3a16bb0bf490caaca557898c5cddd8fd"
  end

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
