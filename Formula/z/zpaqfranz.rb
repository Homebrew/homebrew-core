class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https://github.com/fcorbelli/zpaqfranz"
  url "https://github.com/fcorbelli/zpaqfranz/archive/refs/tags/64.7.tar.gz"
  sha256 "f3eab9d7b26c174a0fb155ce53f15a18c4a9c1a06dce95a3dc028e1fcda8f5e6"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https://github.com/fcorbelli/zpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f7afa8bbe332fe8a424f995cdc084d3173a9985dbca73c3417cf29bdb4a34e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93a3e237229ddb92609fa5a95b81c4dab5705a35adc5e27bdb3fe53c2b7545a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fc658162a0189c17dfd31d48311e9a1e7df97edbd4709e0eed92ab7821053f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dbe6bd617be64e03bd86d5877edae82a13f85dc50a0ef67ece6476bade7bb81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f93bb183859d90d7137a528497dce7fea59142069baa898cfbfcfdbc64e040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82cebcc5777847f1c5b34a182f855de03841baac57f73c97e152a0410443066c"
  end

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
