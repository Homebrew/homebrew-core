class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz"
  sha256 "efccccd2a045da91576c591968374379da1dc4ca2e3dec4d3f8f12628fa29a85"
  revision 4

  bottle do
    cellar :any
    sha256 "5a1078d12ceee6bc9577c865cbf9bd5f1ac6aa681649af79014edf25da4f73f4" => :sierra
    sha256 "d579f8a6851f07491723ba5f0f6fbf28f23cc4d4da64a2dc2f7b5ef4b7589b9e" => :el_capitan
    sha256 "aa06cf46a4fc4c970e968478995258542b1d5252dede792a4b563baa52ce24d4" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils
  depends_on "lzo"

  # These fixes are upstream and can be removed in version 1.5+
  patch do
    url "https://github.com/zbackup/zbackup/commit/7e6adda6b1df9c7b955fc06be28fe6ed7d8125a2.diff"
    sha256 "564c494b02be7b159b21f1cfcc963df29350061e050e66b7b3d96ed829552351"
  end

  patch do
    url "https://github.com/zbackup/zbackup/commit/f4ff7bd8ec63b924a49acbf3a4f9cf194148ce18.diff"
    sha256 "47f760aa03a0a1550f05e30b1fa127afa1eda5a802d0d6edd9be07f3762008fb"
  end

  def install
    # Avoid collision with protobuf 3.x CHECK macro
    inreplace [
      "backup_creator.cc",
      "check.hh",
      "chunk_id.cc",
      "chunk_storage.cc",
      "compression.cc",
      "encrypted_file.cc",
      "encryption.cc",
      "encryption_key.cc",
      "mt.cc",
      "tests/bundle/test_bundle.cc",
      "tests/encrypted_file/test_encrypted_file.cc",
      "unbuffered_file.cc",
    ],
    /\bCHECK\b/, "ZBCHECK"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/zbackup", "--non-encrypted", "init", "."
    system "echo test | #{bin}/zbackup --non-encrypted backup backups/test.bak"
  end
end
