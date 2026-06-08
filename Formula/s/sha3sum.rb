class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.5.tar.gz"
  sha256 "ffc3af5fef56dd4fd920bc3768bb8c7b3303ae1403ff7534f5daf13fe83dca4c"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62306213af7064874641afb494df217e574fb6db5ee52d62aef20a929346c56e"
    sha256 cellar: :any,                 arm64_sequoia: "f6ce0dc6aef6728c0b8fb9115a7b18431e3c432bb3f18f6c452ae5614095e2e5"
    sha256 cellar: :any,                 arm64_sonoma:  "c19a684442e57392c3fd706d7436be87897a20a63a63130388ace81459fb3f7a"
    sha256 cellar: :any,                 sonoma:        "04cb06d81eef84daed5b14c6c787809d09cf79f76a7d10f9319123dc06ae0990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "577ee25a616ed7f4c7e485b6f338584f3c21a0aa3aae69d95975207d171e98e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3db7fb0923e4b66a52ac01e4a7d3935a99cc7b4c4ecabbeabdc401aa75f9b4"
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
