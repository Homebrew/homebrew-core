class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.12.tar.gz"
  sha256 "591a82ddbc2e970630a9426c78c25cbc52c3261b06d57cb4e1f11ab8008629fa"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d04728e1c947b50772a7e725dac606447f959109a2a792544433cb096315e691" => :catalina
    sha256 "f9b428414de3dc7521aa2c612ce050065e442b3c8d36f8a8a05d11da6f39f27a" => :mojave
    sha256 "e8ce344b4827cb8f8abf988d8e4fa17e071bd69512e0dc92cd464aee57a45de7" => :high_sierra
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
