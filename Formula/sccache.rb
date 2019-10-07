class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.12.tar.gz"
  sha256 "591a82ddbc2e970630a9426c78c25cbc52c3261b06d57cb4e1f11ab8008629fa"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "915be21657f33db3e030830e98a80cbc11b45d8777489774353274069825ff51" => :mojave
    sha256 "1b0ba25e94540261cb3c2b4e51fd6e7bc4c5504ec7731ada2cb391b5c6d56159" => :high_sierra
    sha256 "b478e2417a9aa5be0ff5c90de91ee4e810bca29966dca0d3e5b28a06dc6f182f" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", ".",
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
