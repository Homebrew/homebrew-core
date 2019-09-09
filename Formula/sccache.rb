class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.11.tar.gz"
  sha256 "d72569789c4c54e5c8dc20bbde8e553b85497dbd9a3fdcc6d738a4df411dea46"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c621b61c1ba1bfe016cb667b6393767563ae2c7cf56d9d69948193b8cb19809" => :mojave
    sha256 "23a85c09ccc988d05bfe83f69a7cd9c6f2936281641266ffde00efd4b700ad72" => :high_sierra
    sha256 "fc9d87826b46f183a010e98e954d2abc7b72d1211ef4cc947040bd82a23df50b" => :sierra
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
