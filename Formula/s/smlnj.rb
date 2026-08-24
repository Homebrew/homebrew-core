class Smlnj < Formula
  desc "Compiler and programming system for Standard ML"
  homepage "https://www.smlnj.org/"
  url "https://smlnj.org/dist/working/2026.2/smlnj-arm64-unix-2026.2.tgz"
  sha256 "504119bc2cf8fab6f469e33126cdc16769777584822e89ff7e9866c06021cda4"
  license "BSD-3-Clause"
  head "https://github.com/smlnj/smlnj.git", branch: "main"

  livecheck do
    url :homepage
    regex(%r{href=["']?[^"' >]*dist/working/v?(\d+(?:\.\d+)+)/(?:index\.html)?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4ce9d4e7428d7a198fc2e708bcc0c01972d9579e8543a0def9476f233c458044"
    sha256 arm64_sequoia: "3d2763be5e5de582ae81b527c88379721716afa4976468e033719fe5e59bc06b"
    sha256 arm64_sonoma:  "2f5f5684decbd6fe333f95ce3cc6af83b21568be3c946b390d5138eaef5a9ace"
    sha256 sonoma:        "0962303312f1db8c0d989aeb87a7111a9a16180f07917c26cf738e42361520e9"
    sha256 arm64_linux:   "6c711d11aef31e1e65599a49a757d5d1a2eff056e00eba644e56728a997bd8f7"
    sha256 x86_64_linux:  "540523a0a48f9826b00e874bf0ef7f7c3261c66b7e1fb8ee06b5d37fc8e197ed"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "python@3.14" => :build

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

  # Make `build.sh` script more portable
  patch do
    url "https://github.com/smlnj/smlnj/commit/a50972b5a16baf6bd3b41d48c577b28b7d406d9d.patch?full_index=1"
    sha256 "157101e2b57857ef69b261e8fd092b6eaacec06b4bdfcabdb14789af6ff9ddb3"
    type :unofficial
    resolves "https://github.com/smlnj/smlnj/pull/361"
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
