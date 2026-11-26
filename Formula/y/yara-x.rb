class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "4ecb118f9b6d2bef8123bb553d4d8f0c46ae2b43c24a5607521f5904cc55a624"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "46e6055e1b8cc663f778b0c2460912e7558228e888410265ed530b57a55edfeb"
    sha256 cellar: :any, arm64_golden_gate: "bfac89bb39c8f9d335a2ec1b4d7936b0c9581fd3bfeb217f9fcefd7fc2a8ff64"
    sha256 cellar: :any, arm64_tahoe:       "0797769f01ecb7d82624bd4922b6ab61d73470a79865a7792b7350c8b1a40363"
    sha256 cellar: :any, arm64_sequoia:     "9d34ba93a8a89640efcca8ca06569bfde29c1ff60198baccba19b77b451c2be3"
    sha256 cellar: :any, arm64_linux:       "34750ab13a8be1be88c8cc4fa04493ca1abe11c968332fca904c7f1fb1331700"
    sha256 cellar: :any, x86_64_linux:      "8421b48c171e4f1a1c64a91490e4992440f8dc0475f036718ae1444a502fa285"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # Not using std_cargo_fetch_args as cbindgen needs all targets
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "cargo", "cinstall", "-p", "yara-x-capi", "--jobs", ENV.make_jobs.to_s, "--release",
                    "--prefix", prefix, "--libdir", lib

    generate_completions_from_executable(bin/"yr", "completion")
  end

  test do
    # test flow similar to yara
    rules = testpath/"commodore.yara"
    rules.write <<~EOS
      rule chrout {
        meta:
          description = "Calls CBM KERNEL routine CHROUT"
        strings:
          $jsr_chrout = {20 D2 FF}
          $jmp_chrout = {4C D2 FF}
        condition:
          $jsr_chrout or $jmp_chrout
      }
    EOS

    program = testpath/"zero.prg"
    program.binwrite [0x00, 0xc0, 0xa9, 0x30, 0x4c, 0xd2, 0xff].pack("C*")

    assert_equal <<~EOS.strip, shell_output("#{bin}/yr scan #{rules} #{program}").strip
      chrout #{program}
    EOS

    assert_match version.to_s, shell_output("#{bin}/yr --version")
  end
end
