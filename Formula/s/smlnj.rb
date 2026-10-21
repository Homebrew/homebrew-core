class Smlnj < Formula
  desc "Compiler and programming system for Standard ML"
  homepage "https://www.smlnj.org/"
  url "https://smlnj.org/dist/working/2026.3/smlnj-arm64-unix-2026.3.tgz"
  sha256 "7d5826317a8be3a0b347cf4001d5354b9dfdc319f80c26e2c21f265de55154e1"
  license "BSD-3-Clause"
  head "https://github.com/smlnj/smlnj.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{href=["']?[^"' >]*dist/working/v?(\d+(?:\.\d+)+)/(?:index\.html)?["' >]}i)
  end

  bottle do
    sha256 arm64_golden_gate: "89eeed55fbcacbab4b4e9f5e9140c5001aeeca353fafddddccfd783f229e3686"
    sha256 arm64_tahoe:       "90c2bca668f52f10f627b96bb805ac09d53448e03f499bb57cdf87dd3a40d91b"
    sha256 arm64_sequoia:     "f7e037738fad6b2bf09053dcb28dc99f4ad2dcb578145bbf86f80f675a912cd4"
    sha256 arm64_linux:       "cadcb21ed23ded7ec71da376635193b0cf217bf6bc53f4baaefda80b72a6a8e5"
    sha256 x86_64_linux:      "1f042684d922d5e44b14eb2199a785041c7a7d289ab67e08d9b3cdb3340d60f5"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bootarchive" do
    on_arm do
      url "https://smlnj.org/dist/working/2026.2/boot.arm64-unix.tgz", using: :nounzip
      sha256 "510f06c5a69b809dd0a07ea1967582352b31c91ef71f655d2ac6ec82ddfbea4d"
    end
    on_intel do
      url "https://smlnj.org/dist/working/2026.2/boot.amd64-unix.tgz", using: :nounzip
      sha256 "ba0d81bac93a6987aa10687ddb7646f1cdf1c350a399cb76171bfb2b8e1c8ceb"
    end
  end

  def install
    buildpath.install resource("bootarchive")

    # Building the runtime system causes race conditions when parallel
    # make is enabled
    ENV.deparallelize

    libexec.mkpath
    system "./build.sh", "-install", libexec.realpath.to_s

    %w[
      sml asdlgen heap2exec ml-antlr ml-build ml-burg ml-makedepend ml-ulex ml-yacc
    ].each do |cmd|
      bin.write_exec_script libexec/"bin/#{cmd}"
    end
  end

  test do
    hello_sml = <<~SML
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
    SML
    output = pipe_output(bin/"sml", hello_sml, 0)
    banner = Regexp.new("Standard ML of New Jersey [[Version #{version}, 64-bit; .*]]")
    assert_match banner, output
  end
end
