class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Ssreflect < Formula
  desc "Virtual package provided by libssreflect-coq"
  homepage "https://www.msr-inria.fr/projects/mathematical-components-2/"
  url "http://ssr.msr-inria.inria.fr/FTP/ssreflect-1.5.tar.gz"
  sha256 "bad978693d1bfd0a89586a34678bcc244e3b7efba6431e0f83d8e1ae8f82a142"
  revision 1

  bottle do
    sha256 "75090f0085ccce1fa2d9271dd75a984599db927658f642870fd49f1abdbc18b6" => :sierra
    sha256 "a3efc25705a07a1373605376c45f5ba4695c26c49d3c28d47209547467d7c25a" => :el_capitan
    sha256 "5f09ae1cf490a5aac9c0b7aae1d77205af29498ee65423db2836a9d7aa44119e" => :yosemite
    sha256 "70f99bcb91c8299ab2f1e7f3197c3a2579ed887170deac919390a7d8b527ce1f" => :mavericks
  end

  option "with-doc", "Install HTML documents"
  option "without-static", "Build without static linking"

  depends_on "ocaml"
  depends_on "menhir" => :build
  depends_on "camlp5" => :build # needed for building Coq 8.4
  depends_on Camlp5TransitionalModeRequirement # same requirement as in Coq formula

  resource "coq84" do
    url "https://coq.inria.fr/distrib/V8.4pl6/files/coq-8.4pl6.tar.gz"
    sha256 "a540a231a9970a49353ca039f3544616ff86a208966ab1c593779ae13c91ebd6"
  end

  # Fix an ill-formatted ocamldoc comment.
  patch :DATA

  def install
    resource("coq84").stage do
      system "./configure", "-prefix", libexec/"coq",
                            "-camlp5dir", Formula["camlp5"].opt_lib/"ocaml/camlp5",
                            "-coqide", "no",
                            "-with-doc", "no",
                            # Prevent warning 31 (module is linked twice in the
                            # same executable) from being a fatal error, which
                            # would otherwise be the default as of ocaml 4.03.0;
                            # note that "-custom" is the default value of
                            # coqrunbyteflags, and is necessary, so don't just
                            # overwrite it with "-warn-error -a"
                            "-coqrunbyteflags", "-warn-error -a -custom"

      system "make", "VERBOSE=1", "world"
      ENV.deparallelize { system "make", "install" }
    end

    ENV.prepend_path "PATH", libexec/"coq/bin"
    ENV.deparallelize

    # Enable static linking.
    if build.with? "static"
      inreplace "Make" do |s|
        s.gsub! /#\-custom/, "-custom"
        s.gsub! /#SSRCOQ/, "SSRCOQ"
      end
    end

    args = %W[
      COQBIN=#{libexec}/coq/bin/
      COQLIBINSTALL=lib/coq/user-contrib
      COQDOCINSTALL=share/doc
      DSTROOT=#{prefix}/
    ]
    system "make", *args
    system "make", "install", *args
    if build.with? "doc"
      system "make", "-f", "Makefile.coq", "html", *args
      system "make", "-f", "Makefile.coq", "mlihtml", *args
      system "make", "-f", "Makefile.coq", "install-doc", *args
    end
    bin.install "bin/ssrcoq.byte", "bin/ssrcoq" if build.with? "static"
    pkgshare.install "pg-ssr.el"
  end

  test do
    (testpath/"helloworld.v").write <<-EOS.undent
      Add LoadPath "#{lib}/coq/user-contrib/Ssreflect" as Ssreflect.
      Require Import Ssreflect.ssreflect.
      Variable P:Prop.

      Theorem helloworld: P -> P.
      Proof.
        done.
      Qed.

      Check helloworld.
    EOS
    (testpath/"expected").write <<-EOS.undent
      helloworld
           : P -> P
    EOS
    assert_equal File.read(testpath/"expected"), pipe_output("#{bin}/ssrcoq -compile helloworld")
  end
end

__END__
diff --git a/src/ssrmatching.mli b/src/ssrmatching.mli
index fd2e835..1d9d15b 100644
--- a/src/ssrmatching.mli
+++ b/src/ssrmatching.mli
@@ -77,7 +77,7 @@ val interp_cpattern :
     pattern

 (** The set of occurrences to be matched. The boolean is set to true
- *  to signal the complement of this set (i.e. {-1 3}) *)
+ *  to signal the complement of this set (i.e. \{-1 3\}) *)
 type occ = (bool * int list) option

 (** Substitution function. The [int] argument is the number of binders
