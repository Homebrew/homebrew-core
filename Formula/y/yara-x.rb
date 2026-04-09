class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "3a251473fc75673196b0acd678893f90478b83a6dd5ce255f53e2ac086a50254"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8145c5b9cbed98db967f7d18e65f495b9c030742fe451bbb53bccbb410bf6d84"
    sha256 cellar: :any,                 arm64_sequoia: "8b995f24e824249e4194fd93bafa5090a711a5324b1b361d3d2973b8e026dd17"
    sha256 cellar: :any,                 arm64_sonoma:  "7e5eb20d8defbe47d859bcc7ff3d890e2ed57eb8d4cf252d94491733c0c3cd20"
    sha256 cellar: :any,                 sonoma:        "698c75d0501f35acabe38a1c6b3fbc5b9e6b5bb56ce89e3ce02095b51cd0b8fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe293cb27b379f9304e469a6b422e4f156bca377d429d208d4871aab9fc91854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ff7923a43131545a3a952e5df9573cbf52745cf1ffd28ab95146c91a7b32c9"
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
