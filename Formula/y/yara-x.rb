class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "28c60e1e7f4e60d2fca648c92da3a617ae2da7841165c309d111ac7230bd823f"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f42d97f3131b5186fa977cdd7c41fab4c379cd337541e3819c980df0b9abc0d"
    sha256 cellar: :any,                 arm64_sequoia: "315dab4ac3fbc2446e3c8602d89d49adb8e66baa88a76e463ae5d06306667e71"
    sha256 cellar: :any,                 arm64_sonoma:  "950cb175b70d171e442eaa6f933522bd7a666ac8fe5999af3c097fe5486fad00"
    sha256 cellar: :any,                 sonoma:        "1c6a632bf895bd30bd0f8bcb3d6a2e2f1e8cceb4e6ee170608e280f55b0fe51e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0c252d1ee04161e9668e3861f20a01a5905bfcf6fe8b02ab6198217bed478d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093277e16e1dd3b260c1c26623e9d57477a7263c83f3923c38affe958a9aa2e7"
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
