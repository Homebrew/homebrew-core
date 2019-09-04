class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.10.tar.gz"
  sha256 "e55813d2ca01ebf5704973bb5765a6b3bdf2d6f563be34441a278599579bb5e0"
  revision 1
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31bdf1b96a50e026c7ba90e29f5db9a14d1525ed418326fa9630e541e26940a7" => :mojave
    sha256 "6ef70150d5639a61368df3b2a4a166a038cd26fe3194ffaeb335d5f995085fa8" => :high_sierra
    sha256 "a9caa5681b47b7adfd7e50e7754781b3e8a3eb7879b479dbf4c192c16d0b31e6" => :sierra
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
