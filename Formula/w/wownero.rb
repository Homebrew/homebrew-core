class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.1.0",
      revision: "1b8475003c065b0387f21323dad8a03b131ae7d1"
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
    sha256 cellar: :any,                 arm64_sonoma:   "fcb47744629c28e38b394ce3cb035e23997d300a5cdd9df88bd1a235860e4f0a"
    sha256 cellar: :any,                 arm64_ventura:  "2b92d800b9ecdcefd71b4fb9a3fa84fa78ae61f4c0b5134b499134eaa3c44d19"
    sha256 cellar: :any,                 arm64_monterey: "9eb5bfdf90a6ee311595963cab3b7cb7e7aae34dda897f06f975f048adda838f"
    sha256 cellar: :any,                 sonoma:         "34c6811f414fea8e0d19f6053f1ef5af895f1dc264c921bd1e12587655268325"
    sha256 cellar: :any,                 ventura:        "55ed51a6db9fa2b55f4d5a26b7fe1a1f154ac0cbe71902e354b5f11d54576ae7"
    sha256 cellar: :any,                 monterey:       "b70d89d962b51c601dd335ba4da21acbaa21e02c44ac265997dc1db2c45a0378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1ab70959cb2f0d13e761a9bd8d4c2f7ee304cd4253d09e7068cceb59248f10"
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
