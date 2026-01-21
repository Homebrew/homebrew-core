class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://codeberg.org/wownero/wownero.git",
      tag:      "v0.11.3.0",
      revision: "3e302be710f4e6b4f58642989c8e47711362fa56"
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
    sha256 cellar: :any,                 arm64_sequoia: "e853a94c2180d3369de8bb4f5d04cf7ffea7736b3d1d53f17c69b7bfc3275982"
    sha256 cellar: :any,                 arm64_sonoma:  "89cc4a6b275adf3f8e97f36e8cbfa545bf7b892f6e0f26575e47f936cc816fa9"
    sha256 cellar: :any,                 arm64_ventura: "a7573258aa7a6c1aa62858fabdd590b4546d57e3c1c569ba5355361d7e9d7a47"
    sha256 cellar: :any,                 sonoma:        "6f1149d4459630ab60f67a3d84a75e73d933b2dd2885ec215e2dbf05a37fbecf"
    sha256 cellar: :any,                 ventura:       "b31910c666b6bba034ed47c3a6100f6b42ab5e15ab9f5213e4b831ffc2883d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c99746fadcd9c5542b9559676cb78175550a5fb77df7ca024e59c9439a98a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b579603a0d8d4e8f796ef7efb40e6ff5ceab8272bb585b95914991cc2538f720"
  end

  disable! date: "2025-05-11", because: "needs to use unmaintained `boost@1.85` and `protobuf@21`"

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkgconf" => :build
  depends_on "boost@1.85"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
