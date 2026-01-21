class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "951c504c0869ed1e20598c8ab3b374607a412c564e863e2d2cb3ff7800aee162"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2949e1fb7092bb97257203f258a5c13e6ff278439477250163a6f58a23819957"
    sha256 cellar: :any,                 arm64_sequoia: "31900d25eb69cd254bcc7ee06979cadc47c081674d319d5b1b92c81fb9924ba9"
    sha256 cellar: :any,                 arm64_sonoma:  "86e8b4380bb05a8a33858f8424e353c5e38794bdaa771b6631f5c865e3f88bd9"
    sha256 cellar: :any,                 sonoma:        "6870a6e10a69de830283490771bd816f4ee4edaf980743912bfe7201f46fbfc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee3950784b23b3798b7b1567a75ba41c0783e0d827ec79fd03cadb09aed26bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebb517fd43555091f27cb1fdd81abd1bcfb283012279fdbb3854d339afedaed"
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
