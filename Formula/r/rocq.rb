class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"
  compatibility_version 2

  stable do
    url "https://github.com/rocq-prover/rocq/releases/download/V9.2.0/rocq-9.2.0.tar.gz"
    sha256 "a45280ab4fbaac7540b136a6b073b4a6db15739ec1e149bded43fa6f4fc25f20"

    resource "stdlib" do
      url "https://github.com/rocq-prover/stdlib/releases/download/V9.1.0/stdlib-9.1.0.tar.gz"
      sha256 "2d66421c52ed32719a15cb039c368e063c4d85f670e3d142f5eb7415fb427985"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2e2a4c16e90c21d3baa45352ff39df6bc934d643c5e9fecdddf9f4ee3483aecd"
    sha256 arm64_sequoia: "4e5910bd59bf71c5b891591d1f7b039029cbef5415e73dc0bb4448923c403a8b"
    sha256 arm64_sonoma:  "cab7ab2eff645985a0cfe97c53d99c17dac6bcc192d58f7ad5b38d2de5fee619"
    sha256 sonoma:        "c1bd10138d7aa10292f4337e33cfc2721b045572738e8f69d77ac6a90e152f82"
    sha256 arm64_linux:   "f9e9c8d1fef13ded0918f8ba02a9a04e319356bf19a88e50ff69c9e781d2455b"
    sha256 x86_64_linux:  "61bfbed04999eaabaf499bf0c0f884bd16298300ddd0d692bc819d947f6a1fb3"
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

    # dune 3.24 deleted the `coq` language extension. The default (rule_gen)
    # build doesn't use it (only the unused `dune.disabled` files do) and the
    # `(coq ...)` env field only sets dev-profile flags, so drop both to keep
    # building until a release adopts the Rocq build language.
    inreplace "dune-project", /^\(using coq [\d.]+\)\n/, ""
    inreplace "dune", /\n\s*\(coq \(flags :standard -w \+default\)\)\)/, ")"

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
    output = shell_output("#{Formula["ocaml-findlib"].bin}/ocamlfind query rocq-runtime.plugins.ltac")
    assert_equal "#{HOMEBREW_PREFIX}/lib/ocaml/rocq-runtime/plugins/ltac", output.chomp
  end
end
