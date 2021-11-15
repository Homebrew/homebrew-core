class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.1.0",
      revision: "8ab87421d9321d0b61992c924cfa6e3918118ad0"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7fa636de1095aa610a6b995263ed7ef1d55864bc72f9bbb58093b7cf849dccfd"
    sha256 cellar: :any,                 arm64_big_sur:  "ef39a53fc330916136257fa2f8e2019063e544770789b09503b53e4505bea918"
    sha256 cellar: :any,                 monterey:       "33a39bf46590eb74990762f5ad929d0925fecba366a42ef1571e513e164a9eed"
    sha256 cellar: :any,                 big_sur:        "2a7dc81fcfa03e22dfc74d069ccc505a249823ab116ca2f6eabc3e14d25f28f2"
    sha256 cellar: :any,                 catalina:       "2713015081577274b00955f18eca366944e1557cd89ec00d852470c40a543ded"
    sha256 cellar: :any,                 mojave:         "549739d9edb69887b6661b5daa670ac310693c44ff8462ece01629277b6aa263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25b0804cff6eb8b88df6ecb0c72e836b22fd2bde9e78c7426c7c2cdba661abf"
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
