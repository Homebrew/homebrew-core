class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/65.18.tar.gz"
  sha256 "4853475062695300351e2b16f472ed4f462a108007d671338617e073d3810078"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d237f04b381f961238b1eb6f5f80508f9e3e423451699ea4be4b174ef4338473"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc79d967d70b7e466ea7a4e66f878197917eba509c3e1339292436738c3447e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "965fb268f22d780125187c866094178b74343d3ed77a08c1ea5f61ce7b13882e"
    sha256 cellar: :any,                 arm64_linux:       "e2156a67f24623134ba50cad2f063d92cfbbd50fef867b4761fe3c5ae450f46f"
    sha256 cellar: :any,                 x86_64_linux:      "a3149a00ed82b1743bbc8136dbe3a1bb02f2bb87647a624dbd54439b0a632ff8"
  end

  deny_network_access!

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWS/Makefile", "BINDIR=#{bin}/#{name}"
    man1.install Utils::Gzip.compress("man/zpaqfranz.1")
  end

  test do
    output = shell_output("#{bin}/zpaqfranz autotest")
    assert_match "ERROR 0", output
  end
end
