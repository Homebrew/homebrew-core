class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.1.0",
      revision: "8ab87421d9321d0b61992c924cfa6e3918118ad0"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "081e5d143f966063342d63774d83c9e27d9030d692d6e392f58b4d090fc0c8ad"
    sha256 cellar: :any,                 big_sur:       "268c9bde168c46c08aec0bdb81b380e03ff8715530f57b13ed4ef5cc915c7330"
    sha256 cellar: :any,                 catalina:      "ba0f3aab8ad49065074b36d8006f6eb4b7ff76d0c876acd1a7bd4eaedc5b5d58"
    sha256 cellar: :any,                 mojave:        "87774956f2241793c135b8209d1f4c3d03e56e956eec1cb446962ec13a81a1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8b0cb41bf38dd6b7985b96651e8c955e323476d13c280de215cf240f96c316"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  # Boost 1.76 compatibility
  # https://github.com/loqs/monero/commit/5e902e5e32c672661dfe5677c4a950c4dd409198
  patch :DATA

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    system "cmake", ".", *std_cmake_args, "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}"
    system "make", "install"

    # Fix conflict with miniupnpc.
    # This has been reported at https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
  end

  service do
    run [opt_bin/"wownerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}/wownero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 238084 --generate-new-wallet wallet " \
          "--electrum-seed 'maze vixen spiders luggage vibrate western nugget older " \
          "emails oozed frown isolated ledge business vaults budget " \
          "saucepan faxed aloof down emulate younger jump legion saucepan'" \
          "--command address"
    address = "Wo3YLuTzJLTQjSkyNKPQxQYz5JzR6xi2CTS1PPDJD6nQAZ1ZCk1TDEHHx8CRjHNQ9JDmwCDGhvGF3CZXmmX1sM9a1YhmcQPJM"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end

__END__
diff --git a/contrib/epee/include/storages/portable_storage.h b/contrib/epee/include/storages/portable_storage.h
index f77e89cb6..066e12878 100644
--- a/contrib/epee/include/storages/portable_storage.h
+++ b/contrib/epee/include/storages/portable_storage.h
@@ -39,6 +39,8 @@
 #include "span.h"
 #include "int-util.h"

+#include <boost/mpl/contains.hpp>
+
 namespace epee
 {
   class byte_slice;
