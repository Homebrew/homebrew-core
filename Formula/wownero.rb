class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.1.0",
      revision: "8ab87421d9321d0b61992c924cfa6e3918118ad0"
  license "BSD-3-Clause"
  revision 4

  # The `strategy` code below can be removed if/when this software exceeds
  # version 10.0.0. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["10.0.0"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c31343f9936cb03bdc1779f712647ef16658058d4e7d36343f6217fd538e2b7"
    sha256 cellar: :any,                 arm64_monterey: "b627c6af02ba17fb383732cfd73d3e8c6008e411f023de9d41e87040cb4b0103"
    sha256 cellar: :any,                 arm64_big_sur:  "0fd483fb375cb8f15b8ef0ea0834b67598d654f7c2a009b0524d789fe280f4f9"
    sha256 cellar: :any,                 ventura:        "968aa99dc91b2ccf28d9a701597f15617109b405b7dd3b4a9a13d61c20dcc222"
    sha256 cellar: :any,                 monterey:       "1a6df256f7c5770c20d187314b5b17d573d6a66b96f4271849f27cc4cefa745b"
    sha256 cellar: :any,                 big_sur:        "38346fc0d87e8d5b92d258e4c9e95913d294ef78b62c44053814a3464acbb79b"
    sha256 cellar: :any,                 catalina:       "8821221bc24cecae72e59c4a51f7f1e3583c8f2c1759baf26e046b79e94a9c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c47de0a28e479265da68243b21c14a842b78c1661574ac86224736d8e55aab5"
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
