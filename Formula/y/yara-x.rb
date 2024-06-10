class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "342e632409de2952b5718501f1bb0ac0fb30f9ddacaa74f0f29f7fb1f811ffaf"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93c0d6b8b0bc61256b4a8baa69f0c0012f8318280de87a05f621138a4dc4703b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af45dd347dc467923f00a59cf8349362442a1cb2fd74e73df922a5c3566830b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28f88c471c3634ebfc0debc607258c35db6faf854f18392d5cc53e61ed05946d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ec9af4a00acaf8c49d2ce00a529cd63ea61abe9e207c71b747b97439dde63bb"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1172c6efe3b7076f20037495e1b217690d77fb76e939b728ee75cb79f460bd"
    sha256 cellar: :any_skip_relocation, monterey:       "817ae76b912458610e79d387d7e45bd8d76e095332901dc06736c314e4afebdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827535c006de0ebd9281bab2d013f5a8ab26c41f95dc146c9ac3241f6abc98be"
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

    assert_equal "chrout #{program}", shell_output("#{bin}/yr scan #{rules} #{program}").strip

    assert_match version.to_s, shell_output("#{bin}/yr --version")
  end
end
