class Rocq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://rocq-prover.org/"
  license "LGPL-2.1-only"

  stable do
    url "https://github.com/rocq-prover/rocq/releases/download/V9.1.0/rocq-9.1.0.tar.gz"
    sha256 "b236dc44f92e1eeca6877c7ee188a90c2303497fe7beb99df711ed5a7ce0d824"

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
    sha256 arm64_tahoe:   "df231dd84d387ce8914fb260fd24685af7d6da6bb998c9d52efbf13b9718d9fa"
    sha256 arm64_sequoia: "31e208459941d45b5c5e41278f79d6c40cd1abcb0b873c3ffc0df54f6cac6501"
    sha256 arm64_sonoma:  "3aa44bda57467bfb3c27d928ef415e829f5c832ed59dbd4352b7e5ade3614c7c"
    sha256 sonoma:        "5dc6e0ae4cc0764971fce661a642e28120742518254c3ca69c01cafd8e4619ea"
    sha256 arm64_linux:   "b8ba5bae249958b1537e0edc72b0a29f78d0e1a840dadddd3f196ce19546abe4"
    sha256 x86_64_linux:  "8069baf9a8804ce6945b8a808eaa88fa25e1b22b9334053e5570a3b3d7e14b78"
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
