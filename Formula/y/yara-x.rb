class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "afd3222e5861ab9af4ff8dda7ffab9a2576f9467b8c501b8c04031309ada7a72"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "58d0cf3df84a88ed57984999bc408868dbddaf26fb8300af377f2907632ac2c9"
    sha256 cellar: :any, arm64_sequoia: "b551d17b465235b839eb70eb6128fbf74d48ccf1769f4285ddb30ff9a4b630b3"
    sha256 cellar: :any, arm64_sonoma:  "b79c769472ab9691f67ffc3727a7350ba98faddf286e3ab5df675f73080da6e6"
    sha256 cellar: :any, sonoma:        "66ccdf5de7726412aabc4a73f32d18aeccc179c5492225988bed65117c59b90c"
    sha256 cellar: :any, arm64_linux:   "d8631c56a29be4816e0bd4ba8c173568cd3fbd973ae086137f4d38afeb77c158"
    sha256 cellar: :any, x86_64_linux:  "9674920246c179050e49b03ff7f5e40bc8aea25b0069d5406b2ca1940f995f70"
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
