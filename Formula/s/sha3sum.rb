class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.5.tar.gz"
  sha256 "58778e4ec52dadf6d9b21a9665050458db56c67dd7167978bea2464eef354f13"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "6302ca9f0b19f528c9d2b8ab0b3c62698ec98a8e0d23a1fef4a516a3de28e24e"
    sha256 cellar: :any, arm64_sequoia: "e51c856c6039cf07f68188725a788e1e1f9881969497ce2a3145dedac7a4103a"
    sha256 cellar: :any, arm64_sonoma:  "0a46a21a973314ad36f0ee667389a20b224063c1dd11ebcc95c38348f4163901"
    sha256 cellar: :any, sonoma:        "537370a915f214d90e5f8c4968e97ebd57c9eb1b7c95be40973602116bebd589"
    sha256 cellar: :any, arm64_linux:   "64bfa0f6152be1fe7659d0b41e68e82b89f171e4b08aacf9e089f9098628305d"
    sha256 cellar: :any, x86_64_linux:  "ebe8afef7963d226e9b64463b3db4481ba6d4c8ba96a0794fbe12367561fb7cd"
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
