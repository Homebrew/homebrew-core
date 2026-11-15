require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0-or-later"
  revision 4
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "030311ad2a8646176d1d60e593d9829323b27d8412838a6751b850af08d2bdf5"
  end

  uses_from_macos "perl"

  on_macos do
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "perl-xml-parser"
  end

  deny_network_access!

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac?
    # Modify shebang to run xmltoman during build as automatic rewrite happens after install
    rewrite_shebang detected_perl_shebang, "xmltoman" if OS.linux?

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "xmltoman.1", "xmlmantohtml.1"
  end

  test do
    assert_match "You need to specify a file to parse", shell_output("#{bin}/xmltoman 2>&1", 1).strip
  end
end
