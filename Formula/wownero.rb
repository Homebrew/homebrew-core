class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.10.2.1",
      revision: "301e33520c736f308359fe0e406cc5cfa37ccd4b"
  license "BSD-3-Clause"

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
    sha256 cellar: :any,                 arm64_ventura:  "db1ed26a18eb4880834a3a663f25573cdb8d41f85fce1c20eb9e7a49bcdad9b2"
    sha256 cellar: :any,                 arm64_monterey: "3df5e3bb404f8c9cfdac32a93ab4e6cb2305e3d2064b5991c3291a62505b54e5"
    sha256 cellar: :any,                 arm64_big_sur:  "b118cfa2a51e28b35670090f964b67032409c94f1452f4e33d8eff487fd4af37"
    sha256 cellar: :any,                 ventura:        "f2ff50fe9a169bcb7ee60442f26d642fe773dd9dcc8d16a31ab493fa475a3606"
    sha256 cellar: :any,                 monterey:       "a264cc289ae400739d581c51404f10ab90fb29e9b5be4271882c21722a69ea51"
    sha256 cellar: :any,                 big_sur:        "7347f465cbd840a42557bc54e6b7ee7311166387bb0fbe09c8bfd984c9c34285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c4b0d90344ec79eb9f5fc112e2e3881c14b0cb21410f60e03476882d5fd991"
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

  # patch build issue (missing includes)
  # remove when wownero syncs fixes from monero
  patch do
    url "https://github.com/monero-project/monero/commit/96677fffcd436c5c108718b85419c5dbf5da9df2.patch?full_index=1"
    sha256 "e39914d425b974bcd548a3aeefae954ab2f39d832927ffb97a1fbd7ea03316e0"
  end

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix conflict with miniupnpc.
    # This has been reported at https://github.com/monero-project/monero/issues/3862
    (lib/"libminiupnpc.a").unlink
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
