class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.8.8.tar.gz"
  sha256 "4f88c33e4391f492c7d0073df9bffcc666cc1e2ca0a95d6e1035decdaa227b26"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "0582c617fbe468060ad6a15132d7323a55914325345b8daaf2e81d92e8b6e75b"
    sha256 arm64_monterey: "96b42e7055216f1c293ea00150287679cd021b8723d72244d75e6a369d5204c5"
    sha256 arm64_big_sur:  "1660c7cd456b8ce50547bfd0eacf8b447d69267c024bc62deeeb081e57b378e5"
    sha256 ventura:        "e64b3ad74eb8a43b7876bc978d442305651f9ba6507df679c1f73966c9ad833d"
    sha256 monterey:       "2bdc2d8f249c6c025b36863264fa2209e9e81485bf0430a061e23d9c0a061fbf"
    sha256 big_sur:        "c0e1a1f9a27d4976ca94f0c8b4ce4c092147fa5911b29a0f3329b5f63280b632"
    sha256 x86_64_linux:   "fa088a689dea44b3b5506db2eaabc0d43844ceae56eff81a4e28e84717c53d6f"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
