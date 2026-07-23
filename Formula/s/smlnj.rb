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
    rebuild 1
    sha256 arm64_tahoe:   "c7e181578cf2fc684e4894f40ca0537b6e1bf14eea5e6d024bf54e531f2848b5"
    sha256 arm64_sequoia: "602e9365b6d5395cc83f40be0a26fb456a7d472deeef23a650f0f88cc466cb29"
    sha256 arm64_sonoma:  "955e5427747a25e5faeddd7ad6fbc67ac15e09aaf5a037c76e8b40f24f5e4ecc"
    sha256 sonoma:        "292a91c62f8b2d3c71564c27aea673e5a4158f76114cfad31aab3de2c2a6ba2b"
    sha256 arm64_linux:   "e630cd54b1d783b275fcfca53f70755fd3bf3e7425832c67ed69f9b94c8bb6ff"
    sha256 x86_64_linux:  "b9fdf377406f5c744d1b9d61909b4d47c427c307c7a1dcb68f0c91520790fc47"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "python@3.14" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
