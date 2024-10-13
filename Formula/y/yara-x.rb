class YaraX < Formula
  desc "Tool to do pattern matching for malware research"
  homepage "https://virustotal.github.io/yara-x/"
  url "https://github.com/VirusTotal/yara-x/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "ed5bf7eb29b02c7dbc5b697a171b79891d298a0b219d18430dda7687d80d8cdc"
  license "BSD-3-Clause"
  head "https://github.com/VirusTotal/yara-x.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056812f30082c23813aa3ec22f8a1ec01d6ab913926170117d9db7354c0b036a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "340e2b30cf51300a2169ebe2bd8688eac6021016f137aa759d4ab1e4df4c68ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "065ac1bd92b9ece3de6f1fbdbf57fd9acb847177b9b8f0c0389af73dfab2ad05"
    sha256 cellar: :any_skip_relocation, sonoma:        "e49b3a92acd5af51bf9eb52592492028e0551f5b0eaa2b1b3dd71609248e7e88"
    sha256 cellar: :any_skip_relocation, ventura:       "e0d907112656a1ad37e0a03f641b06cfa075dcad31c39ff3ccee9ba6d2096408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f180ddb4b8e34e9e65f0330d394879396e0e7c01095141b5fe002f8abeafb382"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

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
       Error parsing config, using defaults: No such file or directory (os error 2)
       in .yara-x.toml TOML file
      chrout #{program}
    EOS

    assert_match version.to_s, shell_output("#{bin}/yr --version")
  end
end
