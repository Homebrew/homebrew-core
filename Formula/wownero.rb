class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.0.3",
      revision: "e921c3b8a35bc497ef92c4735e778e918b4c4f99"
  license "BSD-3-Clause"
  revision 2

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
    sha256 cellar: :any,                 arm64_ventura:  "13dfbac1e1886d4f362b4c7978e263a3aeeed05fdc87bbf3d4a826f047a68c76"
    sha256 cellar: :any,                 arm64_monterey: "0ac3c34a1d4f2125b73a3afe6577d9e37c1af20cf1773ff00918895190989d22"
    sha256 cellar: :any,                 arm64_big_sur:  "25e7160ff0375be8f0e6b014ebe96fd31284dc10f39c0021fbd840c1635e2d85"
    sha256 cellar: :any,                 ventura:        "e91b177bf2f7bb4ee525f3bac9babcbbea08d764599ff2b4b5feb2e66015352c"
    sha256 cellar: :any,                 monterey:       "ebbb514291c711c1424467581470a1ba2308f22fea361418218221e752d2b5d5"
    sha256 cellar: :any,                 big_sur:        "817b6597ab089f6530ffd716bf43d8a473a183c9c7f2e97565ccad18c4e259eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03741a450a51a2ae8adeb68deae1f58343dd3ad9e106cebc636868ee23e3568b"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    args = %W[-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}]

    # Build a portable binary (don't set -march=native)
    args << "-DARCH=default" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
