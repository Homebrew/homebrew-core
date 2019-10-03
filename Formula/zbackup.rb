class Zbackup < Formula
  desc "Globally-deduplicating backup tool (based on ideas in rsync)"
  homepage "http://zbackup.org"
  url "https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz"
  sha256 "efccccd2a045da91576c591968374379da1dc4ca2e3dec4d3f8f12628fa29a85"
  revision 12

  bottle do
    cellar :any
    sha256 "036ce8ce7718ff59acfafa78de97b4d0df6e5480e415894d493d92eb138399d2" => :catalina
    sha256 "fd35ccb5e8b3c0473c7466e6ad4a109addca069d3f7b62bbbad7a49471816fca" => :mojave
    sha256 "4dd584f0681545a326ea0e2e68cf5258f37053790c170ddd268e2da775ddc939" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "lzo"
  depends_on "openssl@1.1"
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
