class Smlnj < Formula
  desc "Compiler and programming system for Standard ML"
  homepage "https://www.smlnj.org/"
  url "https://smlnj.org/dist/working/2026.1/smlnj-arm64-unix-2026.1.tgz"
  sha256 "2549a8332a28c126313d8f170391fe500a232a5854dd3b05af3277c7b57a6859"
  license "BSD-3-Clause"
  head "https://github.com/smlnj/smlnj.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{href=["']?[^"' >]*dist/working/v?(\d+(?:\.\d+)+)/(?:index\.html)?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "93b1219027b0abcf80a71243e1607c50fc2a5849a734ae89190ce43d1168f5f6"
    sha256 arm64_sequoia: "bb5a27da68e44310858f4df611cdc5f125c8da814d06c188191349ae0aafc113"
    sha256 arm64_sonoma:  "13b5078c334318acab15ea2b2fd17ead939552f7a5e0c620d696f90feb42cf96"
    sha256 sonoma:        "d6da8b8a343b1582f652980f6a08410d2f0f4e9ff0e6dd30ec32c2072347d3cc"
    sha256 arm64_linux:   "141e547aa173e6a4c24667d29daa04547b2fefd2eaeeec702e3eb472036acb9a"
    sha256 x86_64_linux:  "213f6ba81cdecb49d155373e72106177a625bb2310419df123e7292791dd06bf"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "python@3.14" => :build

  uses_from_macos "zlib"

  resource "bootarchive" do
    on_arm do
      url "https://smlnj.org/dist/working/2026.1/boot.arm64-unix.tgz", using: :nounzip
      sha256 "ab2807d27d7ade38b09b80ac96d3de082a47aa707108728fe4edb4199caad7fd"
    end
    on_intel do
      url "https://smlnj.org/dist/working/2026.1/boot.amd64-unix.tgz", using: :nounzip
      sha256 "71a160b8a92114e8e0243b5c39c17a6006f3165da74185dbb560a3bda0632faa"
    end
  end

  def install
    buildpath.install resource("bootarchive")

    # Building the runtime system causes race conditions when parallel
    # make is enabled
    ENV.deparallelize

    libexec.mkpath
    cd buildpath do
      ENV["INSTALLDIR"] = libexec.realpath.to_s
      system "./build.sh"

      %w[
        sml asdlgen heap2exec ml-antlr ml-build ml-burg ml-makedepend ml-ulex ml-yacc
      ].each do |cmd|
        bin.write_exec_script libexec/"bin/#{cmd}"
      end
    end
  end

  test do
    (testpath/"hello.sml").write <<~EOF
      val () = print "Hello, Homebrew!\n";
      val _ = (
        CM.make "$/smlnj-lib.cm";
        CM.make "$/controls-lib.cm";
        CM.make "$/hash-cons-lib.cm";
        CM.make "$/inet-lib.cm";
        CM.make "$/json-lib.cm";
        CM.make "$/reactive-lib.cm";
        CM.make "$/regexp-lib.cm";
        CM.make "$/sexp-lib.cm";
        CM.make "$/unix-lib.cm";
        CM.make "$/uuid-lib.cm";
        CM.make "$/xml-lib.cm"
      ) handle _ => OS.Process.exit OS.Process.failure
    EOF
    output = shell_output "#{bin}/sml < hello.sml"
    banner = Regexp.new("Standard ML of New Jersey [[Version #{version}, 64-bit; .*]]")
    assert_match banner, output
  end
end
