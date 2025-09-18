class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"
  revision 1

  stable do
    url "https://github.com/rocq-prover/rocq/releases/download/V9.0.0/rocq-9.0.0.tar.gz"
    sha256 "82f86646fd3d047f760837648195c73374beee667b1c9592d31c5426e3b43a51"

    resource "stdlib" do
      url "https://github.com/rocq-prover/stdlib/releases/download/V9.0.0/stdlib-9.0.0.tar.gz"
      sha256 "1ab6adc42dfc651ddc909604bae1a54ff5623cda837f93677a8b12aab9eec711"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d1871041b4d1f98648b9cdbea19a5aeab152f0163d53845e3c74e1406a7d48e9"
    sha256 arm64_sequoia: "1c8bf9b1e08912ccf86eceac13285b033a0791d921b5016d5dc9437dc8792264"
    sha256 arm64_sonoma:  "dfd1896ea0ad7e59e8b0aba7b08f9cf1ec52dd64c096421d300be85236d53552"
    sha256 arm64_ventura: "1d7f694924c703f08f8116ee66d2cbb21ea27eecf5fe36a0235d075738c3ea36"
    sha256 sonoma:        "2303c145684cd605824862a5b4fd24bf68ab72348afbd88090c72cda0f1b518a"
    sha256 ventura:       "b83ce741220395e1d45e34f1f3d7a92c16dfc5b825c6e99724758b53992b881b"
    sha256 arm64_linux:   "b71ccca73282fdce2198310c9db26efabb6960115e2a76c2b5f609522eefbb40"
    sha256 x86_64_linux:  "9f7bccdc7ebb68bbf99c31bbe796e5d12cc2e6a32b3859d83510bda63cf9cb9b"
  end

  head do
    url "https://github.com/rocq-prover/rocq.git", branch: "master"

    resource "stdlib" do
      url "https://github.com/rocq-prover/stdlib.git", branch: "master"
    end
  end

  depends_on "dune" => :build
  depends_on "gmp"
  depends_on "ocaml"
  depends_on "ocaml-findlib"
  depends_on "ocaml-zarith"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-zarith"].opt_lib/"ocaml"
    ENV.prepend_path "OCAMLPATH", Formula["ocaml-findlib"].opt_lib/"ocaml"

    packages = %w[rocq-runtime coq-core rocq-core coqide-server]
    packages << "coq" if build.stable? # TODO: Remove on next release

    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-libdir", HOMEBREW_PREFIX/"lib/ocaml/coq",
                          "-docdir", pkgshare/"latex"
    system "make", "dunestrap"
    system "dune", "build", "-p", packages.join(",")
    system "dune", "install", "--prefix=#{prefix}",
                              "--mandir=#{man}",
                              "--libdir=#{lib}/ocaml",
                              "--docdir=#{doc.parent}",
                              *packages

    resource("stdlib").stage do
      ENV.prepend_path "PATH", bin
      ENV["ROCQLIB"] = lib/"ocaml/coq"
      system "make"
      system "make", "install"
    end
  end

  test do
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
    end
    (testpath/"testing.v").write <<~ROCQ
      Require Stdlib.micromega.Lia.
      Require Stdlib.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Stdlib.micromega.Lia.
      Import Stdlib.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; lia.
      Qed.
    ROCQ
    system bin/"rocq", "compile", testpath/"testing.v"
    # test ability to find plugin files
    output = shell_output("#{Formula["ocaml-findlib"].bin}/ocamlfind query rocq-runtime.plugins.ltac")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/rocq-runtime/plugins/ltac", output.chomp
  end
end
