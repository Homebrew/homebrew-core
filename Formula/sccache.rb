class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.12.tar.gz"
  sha256 "591a82ddbc2e970630a9426c78c25cbc52c3261b06d57cb4e1f11ab8008629fa"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1c3e5b089949f526b863ac6e8e37c644401f2d277986f1a4a6a2e48568eb8f00" => :catalina
    sha256 "330ac51414125b5b79e004fed1dffc66683905e2ba881d8b78b35200eb8fef71" => :mojave
    sha256 "db5d3877a9f7956820c468c88a188f3dbfb1e861b5fe1ed8fdf3cce31c9e6c0b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
                               "--features", "all"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
