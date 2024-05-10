class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.1.0",
      revision: "1b8475003c065b0387f21323dad8a03b131ae7d1"
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
    sha256 cellar: :any,                 arm64_sonoma:   "66aee0c27f86ecb1b0e3caaf93ae25ee27da25b6df902abad0184cc0aec2a183"
    sha256 cellar: :any,                 arm64_ventura:  "e7463d258b3e5fb8e8f727a826e3c5e0d3b31333a4c47af297a9156ad5cd0420"
    sha256 cellar: :any,                 arm64_monterey: "adeaa5de1a95f628dac6a7e0c297156fdb682a1c88506d497836cf6bebf0210d"
    sha256 cellar: :any,                 sonoma:         "88ab320c55493c28d1f555a53bdd812b271de7a1c7b49718bfeddd8958f29970"
    sha256 cellar: :any,                 ventura:        "8df745706752ed9c52d12d55901cfeb99392c1e35ec814bfa3300966474f4a16"
    sha256 cellar: :any,                 monterey:       "ebff9bdbe435cabcfd404dde72bd1d6f2b462c81fd358601034125a665e474d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "309674cbecc3d3b542d345f5501716da422b7cfb40ac4d6cb93c5129942f8193"
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
    # Work around build error with Boost 1.85.0.
    # Reported to `monero` where issue needs to be fixed as `wownero` is a fork.
    # Issue ref: https://github.com/monero-project/monero/issues/9304
    ENV.append "CXXFLAGS", "-include boost/numeric/conversion/bounds.hpp"
    copy_option_files = %w[
      src/common/boost_serialization_helper.h
      src/p2p/net_peerlist.cpp
      src/wallet/wallet2.cpp
    ]
    inreplace copy_option_files, "boost::filesystem::copy_option::overwrite_if_exists",
                                 "boost::filesystem::copy_options::overwrite_existing"
    inreplace "src/simplewallet/simplewallet.cpp", "boost::filesystem::complete(", "boost::filesystem::absolute("

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
