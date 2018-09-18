class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz"
  sha256 "efccccd2a045da91576c591968374379da1dc4ca2e3dec4d3f8f12628fa29a85"
  revision 8

  bottle do
    cellar :any
    sha256 "07ca77fddf0e9a79bb5923ace0c64a8ea0ea95ef6bb04e744f7b3f82ba0cd79f" => :mojave
    sha256 "21d8cad2823234c8c3670e5fb565db3024ca7cc4632786b14f3f4ae2b7ec3f37" => :high_sierra
    sha256 "0b89a926af81bb4d7270f8724f7a4e9ec0dd763669603dd480d12f5690c86d96" => :sierra
    sha256 "34bbe1ac111fd38719ea48a27bcb84d5563b5b4ca2579e4b15a9ad6ae224fdcd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "lzo"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "xz" # get liblzma compression algorithm library from XZutils

  # These fixes are upstream and can be removed in version 1.5+
  patch do
    url "https://github.com/zbackup/zbackup/commit/7e6adda6b1df9c7b955fc06be28fe6ed7d8125a2.diff?full_index=1"
    sha256 "b33b3693fff6fa89b40a02c8c14f73e2e270e2c5e5f0e27ccb038b0d2fb304d4"
  end

  patch do
    url "https://github.com/zbackup/zbackup/commit/f4ff7bd8ec63b924a49acbf3a4f9cf194148ce18.diff?full_index=1"
    sha256 "060491c216a145d34a8fd3385b138630718579404e1a2ec2adea284a52699672"
  end

  needs :cxx11

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
