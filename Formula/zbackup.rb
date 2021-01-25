class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz"
  sha256 "efccccd2a045da91576c591968374379da1dc4ca2e3dec4d3f8f12628fa29a85"
  revision 16

  bottle do
    cellar :any
    sha256 "8463384c48b1fc5d96166d15b2e9a29ac42a0d27cb7c82a4076686b7f94a812f" => :big_sur
    sha256 "dbbf40f7f4edf658918a7beaa2c0a6c77c010b7dd18f230bb0a584a8fadfb0fd" => :arm64_big_sur
    sha256 "8fd3d32ae8d088580aad9508af9e2a6cf6460b798bbf8a80ee1f9274ad164915" => :catalina
    sha256 "1601c36693ddea9f1c5426a6f9f772d1e9b09a1a8750b307ac68eb5727525692" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "lzo"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils

  uses_from_macos "zlib"

  # These fixes are upstream and can be removed in version 1.5+
  patch do
    url "https://github.com/zbackup/zbackup/commit/7e6adda6b1df9c7b955fc06be28fe6ed7d8125a2.patch?full_index=1"
    sha256 "a41acc7be1dee8c8f14e0fb73b6c4a39ae2d458ef8879553202f4ff917629f95"
  end

  patch do
    url "https://github.com/zbackup/zbackup/commit/f4ff7bd8ec63b924a49acbf3a4f9cf194148ce18.patch?full_index=1"
    sha256 "ae296da66ed2899ca9b06da61b2ed2d2407051e322bd961c72cf35fd9d6a330e"
  end

  def install
    ENV.cxx11

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
