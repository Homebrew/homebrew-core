class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.0.4.tar.gz"
  sha256 "2aadf26066c396961949656f304cb5d99b76c88adbe30ad923db4e98b10f3bbc"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c9cdefc81f641fd66e29367b3ed33b7a2af3fa57f3740c72a62954e6870c7896"
    sha256 arm64_sequoia: "95cb10d5c670ccae599e39d08ac3849b0ad815e44a0fe1621b0b1c2382130679"
    sha256 arm64_sonoma:  "9a409a5845bb6906b07427f67340168e2b3d6c9929a2eddc63cc37f26689eedb"
    sha256 sonoma:        "ebea2e2b60e82bbd52e7cc1ead1c35d4dd59baffabdd14b7067db9d3730ab85f"
    sha256 arm64_linux:   "f3439dc6a99112966b23e3014d365a2b25383c303a50d49177477a7bd30c6892"
    sha256 x86_64_linux:  "7f4e8468d149400552f1311d7e8917728c653ccdcf110201bddf6c15678ff11e"
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
