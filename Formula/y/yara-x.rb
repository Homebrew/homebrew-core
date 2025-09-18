class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "ad518c29a21eb1d2a2ba2808de538499633acba5ace1af987b789be0d0416994"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbee1c396ae4d9a5de1a9e7292e87edb85a7efddbfc5f48973d74d0555e6d9df"
    sha256 cellar: :any,                 arm64_sequoia: "b1e156487d005579a5661bb099b8037027c4fe7359bddbb5eca1e0ad84f8054b"
    sha256 cellar: :any,                 arm64_sonoma:  "28205adcd00e95ec6cffa459fc96a0ea074b4e1062e4d98c18e798628b0ea369"
    sha256 cellar: :any,                 sonoma:        "09888dcc862a2e7b0b61aa407fa3991b10210a9b68d8e8938a2c97b67dcb8659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d94929f47a20fca6c0788f3214efaad169d7a8ba808dc845011d6eb0f1442e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477888ded674d249f98ea0c06863ba49202a6408eb48f27bcc737ae70b59c069"
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
