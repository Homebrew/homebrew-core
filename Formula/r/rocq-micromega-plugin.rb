class RocqMicromegaPlugin < Formula
  desc "Micromega decision procedures plugin for the Rocq prover"
  homepage "https://github.com/rocq-community/micromega-plugin"
  url "https://github.com/rocq-community/micromega-plugin/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "5ed46c62dfb7c06ad1df2f744bca5a39282ac9787c57433478a87a706e6e4391"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c04708a0953af29c96453358190183f87ec8f0afd7470321e70b88cce61a4db8"
    sha256 cellar: :any, arm64_sequoia: "c3d7c9df193f7f2839292b54a610791e0696736f3efdcd3d84c53de03c1c7053"
    sha256 cellar: :any, arm64_sonoma:  "807b853049b18c8fcfc15bce78a84eb282742e8419cfdcc7a536ff7e4ab5241b"
    sha256 cellar: :any, sonoma:        "ec6d0db7151013988fbd768c35d314d84681364534343afa13100468f12bbdb6"
    sha256 cellar: :any, arm64_linux:   "530462f339caa852f7186e472449869685c4b509f572299e15cb4ab5e7e3411c"
    sha256 cellar: :any, x86_64_linux:  "97621d7474e127377d099fbc804c0c77ea86d22acc7b20b8dabd9ec6998b9b7d"
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
    system Formula["rocq"].bin/"rocq", "compile", testpath/"test.v"
  end
end
