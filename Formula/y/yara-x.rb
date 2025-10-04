class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "f74302102666c11c7e87578872e7cdd354c123139b17b2b7fb206c912766b593"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5676ff1c1a0ec59fbb72f3353d290129a217153870e1751f207675ac298784bd"
    sha256 cellar: :any,                 arm64_sequoia: "9d040f1ffd3ac087f144ee2cd85cac832480d79f69cb2cf324efe55a84a7245d"
    sha256 cellar: :any,                 arm64_sonoma:  "c917d38ae4148d6f59954abd3ca2f927c9045f4b8749f4d6b2ce2122ccaf308f"
    sha256 cellar: :any,                 sonoma:        "96f480ef4c3d8c0c668cb02c20d30bc0a1fd93bc5829fc89640204bcf5cd5f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "026b67265a55d345e3e9075f604cc587a3976c5fb342f45985436d41d351330b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc1214c04297a18015518331bf240f0ba9c963d3a014bec6212786e100eeb42"
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
