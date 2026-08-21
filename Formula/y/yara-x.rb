class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "479abe3e03ce11b6c6b9c4b452d9e5aa50268ba589dad26db6450d225706346e"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5db87f1124465d8be2ae2679a2549cf56f3e0c3cc9e91e762b29d494097e3751"
    sha256 cellar: :any, arm64_sequoia: "2a158a2aa87715fd081f2e5ad656f8bbab58aba68194566aaa56dabfcfc97523"
    sha256 cellar: :any, arm64_sonoma:  "f69aeb955ecc1fad1f3bffb9cfd8f9213fb3410cc275005543c883ae49b0e5bb"
    sha256 cellar: :any, sonoma:        "4095a0147ebc88fd5b67ce2b065378eb8fca2d237d4dc4533c7cdb4738e73bfa"
    sha256 cellar: :any, arm64_linux:   "53d1ae3bceac2049c7566ea7b1ac446bf5a09df0e5e5f3650033b56d6c198345"
    sha256 cellar: :any, x86_64_linux:  "f2eecca320aa2f629a08272c264ce89d1f8aefdec038f06da4250eb1bbba2c03"
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
