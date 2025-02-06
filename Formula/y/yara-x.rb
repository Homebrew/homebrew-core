class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "906a40675136e9a911e3c1c239b9e340823e6952c3b69bfe980f3b1ed0a74835"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da4535c1bfe97f1257dbe2506b747115319712c256b54351eac7ad68258bb2c7"
    sha256 cellar: :any,                 arm64_sonoma:  "7f06e1a079d6eeb0a6b457b59299e30375a8ae26fea6a7773530c736668541bb"
    sha256 cellar: :any,                 arm64_ventura: "d6ef649b8374ede038e59cfba663423554aece8b93c6c52385b95bf6dfe55516"
    sha256 cellar: :any,                 sonoma:        "5e21edf6c3b75091b1da231946432ea864955298b6428b3042444b9cd445486e"
    sha256 cellar: :any,                 ventura:       "62c27f520179bcd673b76e89853eccee3b71db4bf118d82a22a01e0156c25a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64889d8e0020ce4dfa9417dabb1006c97c6010e821f686d5f29bc7a62482b66c"
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
