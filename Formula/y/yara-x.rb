class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4a6b6a24665ef749ea66ddaa7e197412f2cdbc695c01445d86dcfcf4b351dcf9"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9388ffe2aab9727c9d3f2b8b2c6325c39e783e276b2d5a64cb59f18235350985"
    sha256 cellar: :any,                 arm64_sonoma:  "05fd534c090f9fd0ba8a2ced001e74d826c9b7fb0f54c4f18c92cdeb938e5246"
    sha256 cellar: :any,                 arm64_ventura: "cea257bf549a2727ad6e24fe79bda4ff90e5292e396dfb3311853b67267695a8"
    sha256 cellar: :any,                 sonoma:        "7cad8ea8a5a0902d3dcdc08d2af3fa14175cb5c064b49bdbe1ae23ca451b417e"
    sha256 cellar: :any,                 ventura:       "c568c91cb8587ba155b3e27f5ad1fbf38c321e91ffb9a1f6349f31aac484aace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6caf7c8e6e4509593884cc7d857ee3d05e3e0b2866e93ce7ca1be508977b690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f31a9b46d1a3af565f005477666221ec3738432174ac3d967c0f973cd23eb0"
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
