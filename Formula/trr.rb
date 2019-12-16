class Trr < Formula
  desc "Type training program for emacs users"
  homepage "https://code.google.com/archive/p/trr22/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/trr22/trr22_0.99-5.tar.gz"
  version "22.0.99.5"
  sha256 "6bac2f947839cebde626cdaab0c0879de8f6f6e40bfd7a14ccdfe1a035a3bcc6"
  revision 1

  bottle do
    rebuild 1
    sha256 "c8b3b0e457c769fea4142ff484e27f2c9d07d3000e7766c3c9f363b08138bd8b" => :catalina
    sha256 "be5d808046485957b6cece0d725415dd00025d0007f5eaaf04f4259c766f4b36" => :mojave
    sha256 "d8aab4b51d742dc7724a9409074047fab825642b4101b16483af46285624baff" => :high_sierra
  end

  depends_on "nkf" => :build
  depends_on "apel"
  depends_on "emacs" if MacOS.version >= :catalina

  def install
    system "make", "clean"
    cp Dir["#{Formula["apel"].opt_elisp}/**/*.el"], buildpath

    # The file "CONTENTS" is firstly encoded to EUC-JP.
    # This encodes it to UTF-8 to avoid garbled characters.
    system "nkf", "-w", "--overwrite", buildpath/"CONTENTS"

    # wrong text filename
    inreplace buildpath/"CONTENTS", "EmacsLisp", "Elisp_programs"

    system "make", "clean"
    cp Dir["#{Formula["apel"].opt_elisp}/**/*.elc"], buildpath

    # texts for playing trr
    texts = "The_Constitution_Of_JAPAN Constitution_of_the_USA Iccad_90 C_programs Elisp_programs Java_programs Ocaml_programs Python_programs"

    inreplace buildpath/"Makefile", "japanese = t", "japanese = nil"

    system "make", "install",
                   "CC=#{ENV.cc}",
                   "TRRDIR=#{prefix}",
                   "INFODIR=#{info}",
                   "BINDIR=#{bin}",
                   "TEXTS=#{texts}",
                   "LISPDIR=#{elisp}"
    (prefix/"record").install Dir["record/*"]
  end

  test do
    program = testpath/"test-trr.el"
    program.write <<~EOS
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/apel/emu")
      (add-to-list 'load-path "#{elisp}")
      (require 'trr)
      (print (TRR:trainer-menu-buffer))
    EOS

    assert_equal "\"Type & Menu\"", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
