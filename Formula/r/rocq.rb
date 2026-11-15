class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"
  revision 1
  compatibility_version 3

  stable do
    url "https://github.com/rocq-prover/rocq/releases/download/V9.3.0/rocq-9.3.0.tar.gz"
    sha256 "3f0fc283e8644394aa9c7a6e3995b6d9ebbe1e6dda712bf431f9c372dcef95ad"

    resource "stdlib" do
      url "https://github.com/rocq-prover/stdlib/releases/download/V9.2.0/stdlib-9.2.0.tar.gz"
      sha256 "f2ee1cb0b9af3e7b20625f0e9ec4becb7a27bb453d53b9bc0ea3d67bc8b3142c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "ae25713bc09eebdab50517e429304ea475d3eaceca140ba07d514b6e65257efd"
    sha256 arm64_tahoe:       "17b53c4360d77d0e016b56445c456e6764bc5864777dd5d9226d7294568f67f8"
    sha256 arm64_sequoia:     "3a4fb957c7017f447a3a82d8e4f28c82ee84458252d07e1284c8428917f42c83"
    sha256 arm64_linux:       "036b4fe7e0beeb9dc06dffffac6f69a314fdc549a05e934ea3fef98a79e64ea6"
    sha256 x86_64_linux:      "c8d17bcba1dd7cbd4bde281275c913c78b277757e9c942faf24afd4957c575e4"
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
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("ocaml-zarith")/"ocaml"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("ocaml-findlib")/"ocaml"

    packages = %w[rocq-runtime coq-core rocq-core coqide-server]

    system "./configure", "-prefix", prefix,
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
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
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
    output = shell_output("#{formula_opt_bin("ocaml-findlib")}/ocamlfind query rocq-runtime.plugins.ltac")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/rocq-runtime/plugins/ltac", output.chomp
  end
end
