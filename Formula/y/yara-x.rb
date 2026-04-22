class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "c335bbf41f483b4bbaf12b5c573055ba8ae5d4747357e1451ae5e656bc95f672"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e7adeb21ffde1514d2180df99ab8c800962bce1ebc8c4e1b010d8d7e37bf701"
    sha256 cellar: :any,                 arm64_sequoia: "625b6f8f9f24278b2b540568d65214cdac97550451d52296fbb1ae4017672b4d"
    sha256 cellar: :any,                 arm64_sonoma:  "2992e948c6544eba3619d241fe32b2facfd642ff385c7abc7dc26484911d3943"
    sha256 cellar: :any,                 sonoma:        "fc08da36e777bee99891547722ade8511d105b202438f80531d0ae2dc2b8094c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c49acb4b5f0b73da835afe4782c5a4b0605c75779dba421e2cc5b2fbee67b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080dbb0606df0ebb30526bc544e00e722500a1586df5e12bfe46acbe41484889"
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
