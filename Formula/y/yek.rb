class Yek < Formula
  desc "Fast Rust based tool to serialize text-based files for LLM consumption"
  homepage "https://github.com/mohsen1/yek"
  url "https://github.com/mohsen1/yek/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "e74cdfc577bdfb6577324afc086546ff306c7c43053f526e7ae30031c4433ab4"
  license "MIT"
  head "https://github.com/mohsen1/yek.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6fcf250b11638459e68b989b76165c74d94d261e9a6edd4832f825b32ba31548"
    sha256 cellar: :any, arm64_tahoe:       "7f1277d480988802856ba9e76836116096454fac31bef4004dd955e2a5a8d451"
    sha256 cellar: :any, arm64_sequoia:     "52d7d4c969a389d1a9d83d3888419da4e6b972570d737b0f6d0d3c300eae61ae"
    sha256 cellar: :any, arm64_linux:       "919a7a231412e95d3c92eb581ca015deda92e94e624423ba96b84becf42694b3"
    sha256 cellar: :any, x86_64_linux:      "9e8787a06408825a5086419e44784359cbe6d31a1111c3d3170c087366ffe809"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # TODO: ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yek --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main(void) {
        printf("%s\n", "Hello, world!");
        return EXIT_SUCCESS;
      }
    C
    expected_file = shell_output("#{bin}/yek --output-dir #{testpath}")
    assert_match ">>>> main.c", expected_file
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 509c30b..f64f229 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1525,9 +1525,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
