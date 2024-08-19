class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2f60e714aaa9140642f83aef7df012baaf7941ca444995a79c3b99cb4941367c"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d032c6f13c973f37fbdce10716a7bfc75d2e5bfa0b107ba5d3818ec7525492b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "832cd54c22e4b173638f0d33522591aef9abfc04f6c47334665e366c95e9dad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f563aee617d0bb63dac1674e9c2b9fc6968fe06dbeff08838c2516dd70651846"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbd6b3459cc20614decb327e1f925bd5db7d7bb2bf136c0c1526a141e1cab030"
    sha256 cellar: :any_skip_relocation, ventura:        "5650c99f8c066e96cc112bc48f26cf93d1d4855fa5475a649b4dc51580649f48"
    sha256 cellar: :any_skip_relocation, monterey:       "eafd03d8c347fa8ce9b44c15fbb0b9848bf555a7b8417e4187e57f0cd7c217dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c916db31f7ef907f87b6fa4a60ac8b082dfb5edb3a18bbc079e726a17a4141"
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
