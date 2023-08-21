class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.0.3",
      revision: "e921c3b8a35bc497ef92c4735e778e918b4c4f99"
  license "BSD-3-Clause"
  revision 3

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
    sha256 cellar: :any,                 arm64_ventura:  "e9c6d64810d53ccd2fa82a0f641fc4fbf594ce632b18186801083493bf6be222"
    sha256 cellar: :any,                 arm64_monterey: "d53bd08ebda04811356689c342d35fc0344f0906a540d83a43f9b41df447e971"
    sha256 cellar: :any,                 arm64_big_sur:  "7af4e0940aaa43a7d70d3a8cb1970f744f71acdf67e8c7de8e9db913c682adff"
    sha256 cellar: :any,                 ventura:        "16d4dc784619f6a70f0a017abe08d321a9555218ee4c6330589d6cb6f18d9234"
    sha256 cellar: :any,                 monterey:       "e8337a5e74fceca5739b0579aac2c1829dca2ed5379bf50d2e2ec7a3eb7897bb"
    sha256 cellar: :any,                 big_sur:        "bd746ee84a9474879ea9cb224c150d000e7802c5837e1a7ef0d4193d20ca75c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e700986a65ce429419bcdf44fa0339a2b2f01182c9138915df5b7e50dec44a0"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
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
