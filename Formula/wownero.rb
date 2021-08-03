class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.0.3",
      revision: "2bdd70d65d266beeca043f207ebb1964463f4a3b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1f3a68fa3d30af2b68c05b016c7f18e566b39381305c420c62f2585f633864dd"
    sha256 cellar: :any,                 big_sur:       "00e65726bf6e3054c65f5a53564cc237fc18724c8692f915b002b81f1a6c241d"
    sha256 cellar: :any,                 catalina:      "bcdac9d718c91c6cbe3bd0b29b3479857220475e94cc8025151f6271e757e79f"
    sha256 cellar: :any,                 mojave:        "52092bb5e060e9c6136439c28014799f611c60fe0f1d729d842c0f57ec25e797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512fb5190bb1cf7020c733ea3c77873151a2e1cdcd48a9b672a72f9fdcf8c378"
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
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
