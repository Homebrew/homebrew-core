class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"
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
    sha256 arm64_tahoe:   "b8360a844ef669a0b3b08a9a5a3dfe296902688ce6fbad6a7e9a612954e8e47f"
    sha256 arm64_sequoia: "1a8d48139fa5839cdc196c5d4f79823d0a47b6f68f15f367091f16b628fe1c11"
    sha256 arm64_sonoma:  "e534440b771adc163d4ecc14f72ec5efffd6e2e2b4c0f880c47c0dab281a4ff2"
    sha256 sonoma:        "ab3466cbae6cc0d9a150993ef372cb7116b0b8e2347fcb1f63603c1d5327f665"
    sha256 arm64_linux:   "9c307986f20b14744bb1cf125096710f009d8c40a83834ca02b93ac198e730ce"
    sha256 x86_64_linux:  "a537821e69bdddf8dfc88fdfa542adf4e1fcc05886d6056fc4e5bb3c11dee459"
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
