class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "dbcc6509bbb816231a1509017005a690cc726f6344f6876c9795ac9396f5d2b2"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59e164a380852ea6acd130ff44f63c2ebe23f471b395f0024da92a38930a6377"
    sha256 cellar: :any,                 arm64_sequoia: "5091985ef012e3ce1407cd7a09a21ce0515a8cfe966eae05cd389970962fb8e4"
    sha256 cellar: :any,                 arm64_sonoma:  "c1a9eb9aa6a9b1729f26f24e6f67a65ecceb531b8b61ea12cf89bc56e737cd6b"
    sha256 cellar: :any,                 sonoma:        "fb29eb46466f452e7ba0de3a85540e0d5ecccb44fe0e62bc6c569017c9b074fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5abd37f975a6e8c76ef6da5feca8b59b06c353e511c2cf1dfa8c45fec54074ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5948668cfe2556d5d967850b8acbe235e314726c46963e0ef95f3736cea35070"
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
