class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"
  revision 1
  compatibility_version 1

  stable do
    url "https://github.com/rocq-prover/rocq/releases/download/V9.1.1/rocq-9.1.1.tar.gz"
    sha256 "35cd03fc4193969b1cce01190340e5c129c1ba8f02242a9e6dff4b83be118759"

    resource "stdlib" do
      url "https://github.com/rocq-prover/stdlib/releases/download/V9.0.0/stdlib-9.0.0.tar.gz"
      sha256 "1ab6adc42dfc651ddc909604bae1a54ff5623cda837f93677a8b12aab9eec711"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "115c48fed35576b8543ee131ce2e7d76aacbaf41bf26ba748da6e91318ac47e6"
    sha256 arm64_sequoia: "6189d339f699d4741e897e3dd72b5e1b3166882cb5f8daaa0ee1e51577a98c95"
    sha256 arm64_sonoma:  "00d13e12440801af1ca6c5511d1d25ed42aced5b2bb42156ad115add4abfb76e"
    sha256 sonoma:        "d8cc0cb44561d73766ce10cdc1bdf105d07f98d0ba1cc478ea97d199500e4da3"
    sha256 arm64_linux:   "0444ebaece6e0db5bff8c49dccdff11aeda920b641f5bef478ee54a667f7f59b"
    sha256 x86_64_linux:  "d260c686d4408133e018b5035683bd963f4b0844af66f9890307929965f908b1"
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
