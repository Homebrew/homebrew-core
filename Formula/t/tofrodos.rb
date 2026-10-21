class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://github.com/ChristopherHeng/tofrodos"
  url "https://github.com/ChristopherHeng/tofrodos/archive/refs/tags/3.0.0.tar.gz"
  sha256 "3c2e14a33d704b48cde344540095a09e696f6b7907169ae6f2ff78ab54ad6f8d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "342942036f6109280bc10b0a27de08487212f40bbe71aa405a042b8123c7225f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1975780f21d7e2504649dc52b92bc234bff4e58064c0dd93c15da11acc56ed62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8cb6e9524618be985e77720471ffe31fe3e92b2132ed61509caefd537434ace"
    sha256 cellar: :any,                 arm64_linux:       "c7ffd634393777ba666fe599bcf0d505a5f53d82b2378e4deab8e3b8428b033c"
    sha256 cellar: :any,                 x86_64_linux:      "d2579e060f82887c9f9437672fb272a19721e5c78df6de434d9aa15ff82c8eac"
  end

  def install
    mkdir_p [bin, man1]

    system "make", "-f", "makefile.gcc", "all"
    system "make", "-f", "makefile.gcc", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Example text
    EOS

    shell_output("#{bin}/todos -b #{testpath}/test.txt")
    shell_output("#{bin}/fromdos #{testpath}/test.txt")
    assert_equal (testpath/"test.txt").read, (testpath/"test.txt.bak").read
  end
end
