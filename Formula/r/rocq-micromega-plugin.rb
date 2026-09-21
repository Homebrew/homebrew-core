class RocqMicromegaPlugin < Formula
  desc "Micromega decision procedures plugin for the Rocq prover"
  homepage "https://github.com/rocq-community/micromega-plugin"
  url "https://github.com/rocq-community/micromega-plugin/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5ed46c62dfb7c06ad1df2f744bca5a39282ac9787c57433478a87a706e6e4391"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d6ada3d5c0ca2dd30bfb3d3bd4e170e1421309b902eeaed96cf6962375b22bfb"
    sha256 cellar: :any, arm64_tahoe:       "e3b7e603ec115bdb0fc407fb742b0e3bd865e2a7a3f15ad9cae5d19092e5c615"
    sha256 cellar: :any, arm64_sequoia:     "1a67d62f01d5a865bd879f9683fc33674b58fe0c846204b68db99faea7360e89"
    sha256 cellar: :any, arm64_linux:       "cc49aa8e5ab6f3f8a72761cbfa43cf78067b536e15f7766698c0feeede2d748c"
    sha256 cellar: :any, x86_64_linux:      "8bba083d3e93bbc504d526208477edac76a0dc9dd7799157412e3b927093fc2f"
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
