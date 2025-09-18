class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v3.1.0/rocq-elpi-3.1.0.tar.gz"
  sha256 "428958cf39fdf7dedb93905e26c2bbbf4c2fe95bfecfefe648790c712555ec65"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1fdc41c2f172a9d1579558cf44e2e6b62327f2766d72e84c799becfc08bd24cf"
    sha256 arm64_sequoia: "474578df64f8248241bbd00c6710b6f3fc55dd465679e947c436e25346199602"
    sha256 arm64_sonoma:  "54305efe3f9da547c091ce02a19e1c78ce04787793d0f5a8b8fb73b5552372f8"
    sha256 arm64_ventura: "61c933bdd549206d0663a8021874927399492c6dda3023788e76caee87c48d81"
    sha256 sonoma:        "ebf8d0c6d6e4bc422f7b22b5786acea50eeba5a4333250e7edf0b4d5ffd9b293"
    sha256 ventura:       "df0343717792e3f09bca28954e423882e91d527e2027253114099fe2fef99160"
    sha256 arm64_linux:   "64f45a91e1770ee749c8ea50356e83cf8a72024d36abd275555a70cd132406a6"
    sha256 x86_64_linux:  "33d6a84427c50dbe2eb041859faca647ea6371d3bf1e6f65cb74c45dc6a8eaba"
  end

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "ocaml-findlib"
  depends_on "rocq"

  # NOTE: Resources are just used to provide version numbers for `opam install`
  # since we hit a build error when trying to install from tarball directly.
  # The result is similar to using `--deps-only` in other formulae. We can't
  # run that here as it installs a duplicate copy of `rocq`.
  resource "elpi" do
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v3.1.0/elpi.opam"
    sha256 "7b05c5835618d5f07f32ad9a7cde2fd19f4849aca9a1d8411a4ac9d15e3b21a4"
  end

  resource "ppx_optcomp" do
    url "https://raw.githubusercontent.com/janestreet/ppx_optcomp/refs/tags/v0.17.0/ppx_optcomp.opam"
    sha256 "9ddda7e28dabea043a0187acf3d0ff378084e0ef75c9e2003bd0350b83f4dd41"
  end

  def install
    # Use libexec as root to avoid risk of moving non-relocatable binaries
    with_env(OPAMROOT: libexec, OPAMYES: "1", OPAMNODEPEXTS: "1", OPAMNOSELFUPGRADE: "1") do
      system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
      system "opam", "install", "elpi.#{resource("elpi").version}", "ppx_optcomp.v#{resource("ppx_optcomp").version}"
    end

    # Only keep packages needed at runtime but leave them in libexec to avoid
    # incompatible versions causing issues with other OCaml-based formulae
    rm_r(libexec.children - [libexec/"ocaml-system"])
    rm_r(libexec/"ocaml-system/.opam-switch")

    # Add symlinks to reduce subdirectories in path needed to use rocq-elpi
    libexec.install_symlink libexec.glob("ocaml-system/*")

    ENV["OCAMLFIND_CONF"] = libexec/"lib/findlib.conf"
    system "make", "dune-files"
    system "dune", "build", "-p", name, "@install"
    system "dune", "install", name, "--prefix=#{prefix}",
                                    "--libdir=#{lib}/ocaml",
                                    "--mandir=#{man}",
                                    "--docdir=#{doc.parent}"
    pkgshare.install "examples/example_data_base.v"
  end

  def caveats
    <<~CAVEATS
      Rocq needs help finding ML files installed inside `#{opt_libexec}/lib`.
      This can be done by passing `-I #{opt_libexec}/lib` as an argument.
      Alternatively, you can add the directory to OCAMLPATH, e.g.
        export OCAMLPATH="#{opt_libexec}/lib:$OCAMLPATH"
      or use the included findlib configuration file, e.g.
        export OCAMLFIND_CONF="#{opt_libexec}/lib/findlib.conf"
    CAVEATS
  end

  test do
    ENV["OCAMLFIND_CONF"] = libexec/"lib/findlib.conf"
    cp pkgshare/"example_data_base.v", testpath
    space = " "
    assert_equal <<~TEXT, shell_output("#{Formula["rocq"].bin}/rocq compile example_data_base.v")
      The Db contains [phone_prefix USA 1]
      Phone prefix for USA is 1
      The Db contains#{space}
      [phone_prefix USA 1, phone_prefix France 33, phone_prefix Italy 39]
      Phone prefix for France is 33
      sweet!
      brr
      yummy!
    TEXT
  end
end
