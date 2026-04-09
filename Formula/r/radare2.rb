class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.1.2.tar.gz"
  sha256 "f0677266eeb505bec4df12961cbb2adb92cf8202ff3dab05690bcb24c4bf5c52"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c66e164a25e51f9541809dd9805ec73c4a32be833668567e55cca46ea51240de"
    sha256 arm64_sequoia: "9ab9a6576292eb3ecd8d60bb0cd9072295e7095bdce49756397837a7007c0a3f"
    sha256 arm64_sonoma:  "a296a11560c19a53b6ea46aea77072037c1a22670db277ffa2b0eaf4eebc8104"
    sha256 sonoma:        "cae424479ec46e426c7b40f216167fdbe4e2b2f91c8deca416533ed306f0098d"
    sha256 arm64_linux:   "93df5fd2ee1c6f04af6cf8df40958f0226b588170ae717a0165a339ced077eea"
    sha256 x86_64_linux:  "1918965bb1cc81e5adbe486e274c03f8f70086df3776482a832d5b70cc659d7a"
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
