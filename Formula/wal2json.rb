class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/wal2json_2_3.tar.gz"
  sha256 "2ebf71ace3c9f4b66703bcf6e3fa6ef7b6b026f9e31db4cf864eb3deb4e1a5b3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f3ff6d1b451198b891c384e197701cab3f1ee1c1b439d7413855bebb338776b"
    sha256 cellar: :any_skip_relocation, big_sur:       "42d07ec8236e2e24a592524d32a2b1b2df6e43683f5a98b2f2a25a29ccef0b1a"
    sha256 cellar: :any_skip_relocation, catalina:      "ec25d4dffbb7b4205565f2ec5ad6c17fa62a965d841a75b475b11bd7ff759c51"
    sha256 cellar: :any_skip_relocation, mojave:        "fbe884982b54b6d4c17a608f8f861368322cc7f74024b20516632f83ccc7fbe4"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f382e783fbba2a97a79f0bda4db61211e3fbc4b5d2d859daa777ffa6845dc8ac"
  end

  depends_on "postgresql"

  def install
    mkdir "stage"
    system "make", "install", "USE_PGXS=1", "DESTDIR=#{buildpath}/stage"
    lib.install Dir["stage/#{HOMEBREW_PREFIX}/lib/*"]
  end
end
