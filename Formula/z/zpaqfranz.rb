class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.22.tar.gz"
  sha256 "a391057091ff647de76f035ea87d7d9f0b6274e2d04be94fc9c80d660900203c"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d8363703190aff6ce408e40ac43b677240432582fc7e58c9ff30934e4dd2df5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a547e8f681d12642e433598494462dc76f48416a87b59a73560b2b5c811572e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "041ec22163b24608aab36a772740017f4a190df1e168018e3003b03fde2ad5a2"
    sha256 cellar: :any,                 arm64_linux:       "0132facd50cd1f17b9310664fe597179cd9ff0774b6e4dadff0b739413ac5032"
    sha256 cellar: :any,                 x86_64_linux:      "4b55bf78a8ec4810fe5b7d6a04c005c5030ed3303506974398beedd4a8ee97de"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "PREFIX=#{prefix}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end
