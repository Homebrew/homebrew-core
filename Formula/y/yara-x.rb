class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "90bbe970a85ff2c707b2706a89cb165cd5b8c706451cfa4b25e0aaa77250a6da"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "241017c95d97f39e29730d0d51ede05cb5d943934a7d78fa51990a0aff3d9406"
    sha256 cellar: :any,                 arm64_sonoma:  "a3ef596bb84a5f2d0168dcc1079bd261a9ec8cd50646b738ffc9fecc0b15e60a"
    sha256 cellar: :any,                 arm64_ventura: "8d3c52a044cca700e1c1d9e3b2d807f9760adbc513b787ed128994c4928ff504"
    sha256 cellar: :any,                 sonoma:        "85afc2e825ceba6a13e6ff6061be2bdd451af1d8a0293066c8cab13e28ccad77"
    sha256 cellar: :any,                 ventura:       "5f156f595d7860ce0ee015413bc04b38ee4dd348b3cfe714685d0b69948bfa8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7919951cd67ef7d57570c87763581d2c12ce381dc2951ac1e989df24f3bbc90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f036347d37eb1ce446004253bf99ae9de37bf662bfe1a18808bf37802c8a95fe"
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
