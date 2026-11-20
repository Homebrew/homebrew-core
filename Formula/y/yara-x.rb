class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "c2727bc36dde79d6d2ba048c4318a4eba04c3ac1dd8a5a56abdc5af18340f509"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "12dbb6834bdc15eda7f6d628f07df7b297a50acc5f0cafd4949e4cbb6c3d936f"
    sha256 cellar: :any, arm64_tahoe:       "6260040505abfdc06a4f4494b9fa487c294542f8a9990df4f990941c88c394a8"
    sha256 cellar: :any, arm64_sequoia:     "71abfbac37520292d0b1ff3bcc6570ddecbb533c0510cba6cfe7bed08e569830"
    sha256 cellar: :any, arm64_linux:       "8a2b78160146179d68cb07b4f48d1e47e09c348facaaa54fad2822ef5fe3a900"
    sha256 cellar: :any, x86_64_linux:      "43cfe69f77a58f85bb75a9ec434a0a0ca0398fc3e6ab2df0d0f00791e12091a2"
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
