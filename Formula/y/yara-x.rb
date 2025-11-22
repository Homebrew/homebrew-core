class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "e45d8c0c7c705f1acf7b403402ae64109e1ad7ccc970437e32f9fdee29d0e1c2"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c740fbde1311227a7999597f5a8f8d1e605934b03b828ab952cad3dde2635224"
    sha256 cellar: :any,                 arm64_sequoia: "457a99731bc3063af2c53a35d87694b5ff566b5991faa9b3af6db8603c835891"
    sha256 cellar: :any,                 arm64_sonoma:  "161e659f0054890d428d5225a685dd7bf8d41fcec40d914669a80c57f5454406"
    sha256 cellar: :any,                 sonoma:        "97b82e0978cf40f5fcec76162538249c910dea60ab842b82657384455910a3a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789d6d2a027db7b58de74b845127ef9a15b3b8408177f7307c2a0e089445f853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01732189f34a1f750bada5e22bd1d7aef77a28cc939bbab34b110463a96999a"
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
