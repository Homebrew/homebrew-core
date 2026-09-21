class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.2.2.tar.gz"
  sha256 "23dea90732c76f53cc488ffa21f9013e37338583386e6fed89f7018f120f1cc8"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "e438e02401cf015d93aec9c676c25fa88fddc73ed7e2236bc4a3909e71a80e7f"
    sha256 arm64_tahoe:       "b382dea6fa4765fda88ac0331a6897e3a6994ab4fc12dc13985760a5b939f377"
    sha256 arm64_sequoia:     "62bf486961685bc340840571ecc1a99299ad8b3c2ee2ed729b83a99fc7129b80"
    sha256 arm64_sonoma:      "94f0b21c966b2dac2f604ac8197a2b34e326a6170524b6c4bf01c848ce36d907"
    sha256 arm64_linux:       "4e0867063bc6dc8da7043c63d2c4a5e989376c307500cb0cc2133a0cd3b28480"
    sha256 x86_64_linux:      "38ce6203a3546fc17b148d6f70590503e8b1345960f1572f0e3730d15ed0930c"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
