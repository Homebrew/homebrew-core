class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1ae81cc3fb37966ea23d4a4088413cd19f209309bac38bf420a35ff1d5b3e46f"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e7ad1594f37f4454ddee1c8c277669cb3082b41c92c13fca7e31eef921374b3"
    sha256 cellar: :any,                 arm64_sonoma:  "4deefc5b457fcca063c2ec83992c6aebe29b7c5fb810445bc75fb4553aa26e48"
    sha256 cellar: :any,                 arm64_ventura: "f42df28691473707a1376c86032baad7cc91b1537bbcead88db8ff60a16df87e"
    sha256 cellar: :any,                 sonoma:        "d0a88ae883781eccc3a684cdec06acc5ca7e77a6ea9eaa94ee0b9dafd826961f"
    sha256 cellar: :any,                 ventura:       "a796498e4ae57c4952b351904cdf23adc78efa0b41c06a5db5a5f7c04686222c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c618b89515aac3a1417cd4f116cc6aa65bd5d966f7af94274b9bcfc28fb2181b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985ce44a823642a30d8132ac67de6cec26beed4fc0d55e68f2894fe5e0d757bf"
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
