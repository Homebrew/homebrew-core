class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3bb65368677abad2451e070871f28fc06ef03a6f4f9be4c9081754ca279727fd"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fc742a796289cfe78b40537a796618de5cf74846cf370bf1564a0895a57b2160"
    sha256 cellar: :any, arm64_tahoe:       "dc2496b2d553a58b0418a55712ff74ace40db9895b8e9165b4423a9da5e3cc3c"
    sha256 cellar: :any, arm64_sequoia:     "840bc2e72baa7e1a02b79f50e4cac7e1604cfa738440bc026fcab8d430641018"
    sha256 cellar: :any, arm64_linux:       "21415882cf7f1d224af130f74c68fc3b60804203576218ef1143c50cc1477d22"
    sha256 cellar: :any, x86_64_linux:      "8c1c3d279ceaabe545f000097f6d4c840e1f3cb81181c7f41737f43f76fe0ea1"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

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
