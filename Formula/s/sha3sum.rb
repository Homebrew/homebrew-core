class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.4.tar.gz"
  sha256 "988a33d806ef96063c85b86919b200fa520cc97669823eb74260497609e34876"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "196e039dfd0a59bd58b165bb5750ca0d9aa61b3731f7186ebbf9c77a58af8f2b"
    sha256 cellar: :any,                 arm64_sequoia: "f08834f4269895204adfddc2b0a3ae9ebf576090c3b9d1badcf30a5aa7cee398"
    sha256 cellar: :any,                 arm64_sonoma:  "f593715239ade543fa8ea6f236d0c4dc4ea0eae3990a702ee650523bb0c43191"
    sha256 cellar: :any,                 sonoma:        "5e7ec33ae779d189b665a2d37c3f448cd881ab52b4463cacb78236df6aace2e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb109976a8f23bd0cbf029c9d27a4e7aba8e932cf559a955deb52c1a38665d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5067fd0fb3a94ea541cdb58f5a67e9eb1f6d5b0e84690c2d9460c9e05b5f85ce"
  end

  depends_on "libkeccak"

  def install
    # GNU make builtin rules specify link flags in the wrong order
    # See https://codeberg.org/maandree/sha3sum/issues/2
    system "make", "--no-builtin-rules", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
