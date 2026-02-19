class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "a1690ad36b08fe0acd33916d4446deebb9adb8577f9a3720fe8559ce09b4549a"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b8af0dbb9d2e08f42504653e46caf439e431ad7d242473c8002e2a9dcc6df3c"
    sha256 cellar: :any,                 arm64_sequoia: "e1a419a8efac7ad943b4c3e95a4cd0cb9f9aa9f9b136a2e65716d9ae3c72e742"
    sha256 cellar: :any,                 arm64_sonoma:  "17be63026b0cce74e16f4a2436127f74239e8becd5654822413cd52af7a26460"
    sha256 cellar: :any,                 sonoma:        "60f0a8b0cfe81e015b156caa4613a7ed49ad2187fc74a312244c350d4b3209d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6e431bf97f06dab742d3cc33016cb69e82d74a122db41e68a7b1f73f044344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbfccca8c3ed369fc4989924bd6949ec3ec3028d4080884170fe57774c4d805"
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
