class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/5.9.2.tar.gz"
  sha256 "909a39456196220b2b8433da370425afe2244d34ea6b84b933ecbec6cb285264"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2df4418388b80cf640aa92f6bb5cfee978b5e22fc8a523c09efcc37eb95320d4"
    sha256 arm64_ventura:  "0f2a82d3691c58b112af421d0116a0ba7e9cfdfe240b5bc13e6d84e985f71eb8"
    sha256 arm64_monterey: "6dccde57c6529e8c5ff5947e1111ac06b1cb9e31dc2b6a0c3293b3b3be189782"
    sha256 sonoma:         "a8dc907594cd2a2ba55243887d32475aa1da1b10188f3583febc4b750237711f"
    sha256 ventura:        "ace1f953ddd8f8b4e1ab01219b3e8d92e44d465a777680f94d23f9605079438c"
    sha256 monterey:       "da49ba2758c1e2256ac4e6c8afbf98af8dfd3975026fdf417c366412ac2c78a3"
    sha256 x86_64_linux:   "6c49af1c9df30a56f2e37852e75aef9b0a3489e42cb27d85cb207bfc91395910"
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
