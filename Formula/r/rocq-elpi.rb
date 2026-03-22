class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v3.3.1/rocq-elpi-3.3.1.tar.gz"
  sha256 "97468eea82299c7276ea5e1047342e8897de5a437a357e595a5728183ea66721"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "66f5f79c9c0b247a4f4c257918e0060c8937d55356a9fa7ca899921be590fd2d"
    sha256 arm64_sequoia: "4006e4d8afea43f2ba2f126cbecdc7b60cadd6d85d5d94546f48db09ba6b2e41"
    sha256 arm64_sonoma:  "2f95a9e10ad415d91f6776009016092d7cb9ad6cd6cb6707be0b8246592c917a"
    sha256 sonoma:        "f940e54ae99807217f998c0f3207d7716be6d3611fb78a3b3bf06c5efa0a6f3c"
    sha256 arm64_linux:   "8ed9b4772fb83b3987a52021245e1bb9fff7da3aff1fe73bdd7b5df4f049ddfb"
    sha256 x86_64_linux:  "7b8c260e31ca799133d58cc8db868b47be10961b1fc1f1c5e9f029ff685d38b7"
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
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v3.6.1/elpi.opam"
    sha256 "24e253b1cd5afb678f0f1e0d7f340ac3c549cf974a5c029a402c2fab5d582635"
  end

  resource "ppx_optcomp" do
    url "https://raw.githubusercontent.com/janestreet/ppx_optcomp/refs/tags/v0.17.1/ppx_optcomp.opam"
    sha256 "59af9cf06bdc1d2682de3eb95bd179e48659d4dc76bd60e15feb5fbe07d42400"
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
