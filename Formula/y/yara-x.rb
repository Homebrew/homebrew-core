class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "d01d74cd1df2761bd63325138964ac5fe9f9c9f52636910d19e288a16a8b2630"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aec5a6fa948b7589ff57f000e15da81539586bbf9c03268e627bb3b57eb44dbc"
    sha256 cellar: :any, arm64_tahoe:       "832341f7b6fd7e6e110118ef0e85fdb6ca2ffb60b2b5023bacc20c0ae87150f2"
    sha256 cellar: :any, arm64_sequoia:     "f3ae760dfb001504fb38f52f9c3d43c376b023ae7c4668fc9b077bca49ab0c19"
    sha256 cellar: :any, arm64_linux:       "328c447931f4db465d81a98540f6aac58ddf23de65aff4697e495d6ccea23a93"
    sha256 cellar: :any, x86_64_linux:      "e6029064afef64572156e2dab001425ece3f8c455c71042ebbdc85aa3cca3261"
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
