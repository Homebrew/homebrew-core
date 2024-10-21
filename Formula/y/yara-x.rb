class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "acbdb4e3602a186b9c6c8d4ca1c6949e97c4935025d64ee4e86d27ed532852fd"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b4eb110d016e1954ec450a778a3ec9d14c6bb3a9323ec965969e3c2b64a9d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd15c820e252ba50a51db67c7b95f95e8bd7a77fae87e99b6ceb3bd9c4fa0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac4e35c956a2aae12878d89f7f8fcf8c51403ba91188d37b10a14c5e19fc5d10"
    sha256 cellar: :any_skip_relocation, sonoma:        "94c9d120c71a0e0a3030b475938eb3f2abd1c3607060d35ca3ff1889c46357a4"
    sha256 cellar: :any_skip_relocation, ventura:       "22fd823e478e90a15a273a9fc149e158d90dabf2c2d8aa2bd946af5a4e8162d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df56435d2687920824df1b6c2c34f30f9c2740a9b161cbd38fb4c16ca56d2f6e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

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
