class RocqMicromegaPlugin < Formula
  desc "Micromega decision procedures plugin for the Rocq prover"
  homepage "https://github.com/rocq-community/micromega-plugin"
  url "https://github.com/rocq-community/micromega-plugin/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5ed46c62dfb7c06ad1df2f744bca5a39282ac9787c57433478a87a706e6e4391"
  license "LGPL-2.1-only"
  revision 3
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1a0ddc19777d388dcc8f70ee6f66fa8785dddd175735d8db5fc56a4d01321529"
    sha256 cellar: :any, arm64_tahoe:       "5c3f24ac5f16887901f6fdaaff4659cf04e489581ce978b30e6f9099e3c08e92"
    sha256 cellar: :any, arm64_sequoia:     "a2e8b442c1165a0d5a8ae2e260e739f7e6c981735f1a335f2de0e033e64600de"
    sha256 cellar: :any, arm64_linux:       "57fe624ae588bd3a32ec4f60fc26a6424161fe42410ca4b68033d309e97ba373"
    sha256 cellar: :any, x86_64_linux:      "886456b8b032e0826ff4231246292ab07a51bb3cd4557a3fe1846d284820b474"
  end

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "ocaml-findlib"
  depends_on "rocq"

  # Only used to provide a version number for `opam install` (build-only ppx)
  resource "ppx_optcomp" do
    url "https://raw.githubusercontent.com/janestreet/ppx_optcomp/refs/tags/v0.17.1/ppx_optcomp.opam"
    sha256 "59af9cf06bdc1d2682de3eb95bd179e48659d4dc76bd60e15feb5fbe07d42400"
  end

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", "ppx_optcomp.v#{resource("ppx_optcomp").version}", "--no-depexts"

    ENV.prepend_path "OCAMLPATH", buildpath/".opam/ocaml-system/lib"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("rocq")/"ocaml"
    ENV.prepend_path "OCAMLPATH", formula_opt_lib("ocaml-findlib")/"ocaml"

    # dune 3.24 replaced the Coq build language with the Rocq build language.
    dune_files = buildpath.glob("**/dune") << (buildpath/"dune-project")
    {
      "(lang dune 3.8)" => "(lang dune 3.24)",
      "(using coq 0.8)" => "(using rocq 0.11)",
      "(coq (flags"     => "(rocq (flags",
      "coq.theory"      => "rocq.theory",
      "coq.pp"          => "rocq.pp",
      "%{coq:"          => "%{rocq:",
    }.each do |before, after|
      inreplace dune_files.select { |f| f.read.include?(before) }, before, after
    end

    system "dune", "build", "-p", name, "@install"
    system "dune", "install", name, "--prefix=#{prefix}",
           "--libdir=#{lib}/ocaml",
           "--docdir=#{doc.parent}"
  end

  test do
    (testpath/"test.v").write <<~ROCQ
      From micromega_plugin Require Import PosDef NatDef formula witness.
    ROCQ
    ENV.prepend_path "OCAMLPATH", opt_lib/"ocaml"
    system formula_opt_bin("rocq")/"rocq", "compile", testpath/"test.v"
  end
end
