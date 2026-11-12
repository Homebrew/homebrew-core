class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.20.tar.gz"
  sha256 "9c2e2267e1630d1eb842abea4932404c056f6be55926c534099e61cda3d72502"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3a7f7697976050c9d57c10ecbad883645aedf2ceb199862c9ef840cb6389957"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a07f8b341b1b6ff33639cb7fe78573b2eae82b6ba60e54b1ad480c2bd0d13eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8453ce2a43af13b5f1418f4211d1095bacd2e57aeee41dca942dba85a8a336c"
    sha256 cellar: :any,                 arm64_linux:       "cc1c2792f1c672ff1edfd888fb2feefa89c6dfe7d4a4bb6ed11f3868bb8d211f"
    sha256 cellar: :any,                 x86_64_linux:      "549ede42c93b66b76fbdfb041c4bd419c57200d13443bca088643048dbed5fdb"
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
