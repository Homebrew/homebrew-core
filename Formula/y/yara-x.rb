class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "86036741a5c30d1e6ecf3fe11b6b4a79fb7e9e534a03479c036d66de8b20f657"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7c6062124c983aec8510902cbbd640735ca1f103a647c3b60fe0160cd8944df1"
    sha256 cellar: :any, arm64_tahoe:       "b6c3a49c9e8019b1c6ce3a58ec7730624f3d91aaffeba3d4b1d34260539f5941"
    sha256 cellar: :any, arm64_sequoia:     "8e29b9db844d2a9da6d5d3294e20d5b8000da9bc08e0c5c1ad0ed224a724ed42"
    sha256 cellar: :any, arm64_linux:       "f291a7bb8b4e708ef257baab331cd8f4a2fa5aa1862e6bfa67a81feec52c7484"
    sha256 cellar: :any, x86_64_linux:      "373943f078df2ec56b02fa4cb07d49223ceda6103b66bffebc0e7b9fbd4cbbe2"
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
