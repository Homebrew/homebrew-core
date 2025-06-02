class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6fd6cdfb85f8281bfb3e56fc57a93b3c3b9adfa52406013ac0088f2ac4e3b181"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47fd112256fe8519e4c20d624b57a2e1502d8fc1a694da756d7855ea85ef628e"
    sha256 cellar: :any,                 arm64_sonoma:  "c27692087b0bebfbbab915ef54c44f0361a152d6e53ea3503a9544e1c7fb0c5c"
    sha256 cellar: :any,                 arm64_ventura: "ca693f836f6784024fc63768f95cc2661d549f2cd5458f8e09b8eafa2fef76ea"
    sha256 cellar: :any,                 sonoma:        "1909de0ed7618468864c5122b07ba41270eed52c53a03aaa7e3ca342f3d40c27"
    sha256 cellar: :any,                 ventura:       "cc0d2755892b88792a025e1dd31bdc338f09aed99dd2f4df30bb4067cd2ca48b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c82571c10a1be5158d83c721dc353630c3c18ff7904a84e727df309739fdbc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2b2a11335ea88716133af9cef59b344dd58fe469ba44cb06462cd3fe5eca22"
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
