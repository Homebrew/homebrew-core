class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f73f7c3d2b38e7190d9b588bbc4eb6664123cd95a10c30e198f0653da1db8932"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf35e2c0e39fb7959945c139b6d74d36c5f0977087aa53bc869572e804e9ff24"
    sha256 cellar: :any,                 arm64_sonoma:  "9cc3b18bd091c5cf660c147db7828a1b5e2f31464b22303dd9ba827fd428919f"
    sha256 cellar: :any,                 arm64_ventura: "1ddfe551dfd0afb79cddc2933b4602a3199fc25eb0cfcbf63cb67588671f2d13"
    sha256 cellar: :any,                 sonoma:        "f54fe9b68fb8a9f47341bd2a46ed157eebfdd6af7c33549a6f66b942760c9b1f"
    sha256 cellar: :any,                 ventura:       "32566be496260b1c392236a807e91914a4d04f8ea506f09786dcc5f135cb1c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9005a10f98aff7f432e9e1a4693ca4347759fe6e0a5e1e1add6f96deada66dd3"
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
