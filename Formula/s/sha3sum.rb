class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.3.1.tar.gz"
  sha256 "82c0808b11f4ba039531b22877dd68e4d870f53cae0c23b7c5d22d40312129f7"
  license "ISC"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "7a4fb57d1ba121089050fc79e69725343ef7aaa39f9d5d9f4c86a6071bc81e42"
    sha256 cellar: :any,                 arm64_sequoia:  "123cc2c228d8770644c184f6e1a0da0b2e4398bbdf4aff9cc2465a5bc59ac41d"
    sha256 cellar: :any,                 arm64_sonoma:   "8d980021fa368d031ffecc790b2651fe9a8e12514527a88e5c53d58dda8d25ff"
    sha256 cellar: :any,                 arm64_ventura:  "23e518f210d7ef6d97b36328e3014fbf9c10f06b455c9f606793230ad4ce50ca"
    sha256 cellar: :any,                 arm64_monterey: "c46d9a5c481fccbfe4b5320de6819cab08f8e645c7ce12e38297cfb62d89591c"
    sha256 cellar: :any,                 sonoma:         "ffb035e4498574c19d6532dc55150177ed9b2392d1b02f1da845dfea33f81090"
    sha256 cellar: :any,                 ventura:        "5ced828831e4a51f393fb43405c0ea20545c60499454263e1ad44daa0ccea1c9"
    sha256 cellar: :any,                 monterey:       "8c723139a1467bde4d19a713fbf48ac04b92578acc4f10a61598f3c8b1676d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ed7328e39c51349010f88510de20b85c2d85760c5c2fdaa2d03a095743317c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b39669c216c9754961a9c54d0ffc1e96c425948823bc159da40a700a277e1404"
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
