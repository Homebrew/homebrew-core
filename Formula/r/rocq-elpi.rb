class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v3.2.0/rocq-elpi-3.2.0.tar.gz"
  sha256 "46e2e9baa79c7376cf1afb132a6aa9edc256e9c386d0a5f7ddef5fa136e98759"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2da325e513a39adb79ecb5e8cf05a79312ef1d1dd61153418e31710a0d892e8d"
    sha256 arm64_sequoia: "92c552c672119f646308d2d44c912d9d615a3c23878489d3a0f12f7c8cd3aec8"
    sha256 arm64_sonoma:  "d251297888afd3d1991a0c2d2cd0c5efb1d5655edb4ad267999ec0a5eb288361"
    sha256 sonoma:        "61059ec4126dfde0143cd76d3cd31f2b2618edf1f47afb3654f91bf8d69072b3"
    sha256 arm64_linux:   "2404e71feb1d66bb5ec3df4045600f92aac10da7a077087c34ce452e5bc6db9f"
    sha256 x86_64_linux:  "c312095185bdfffa85a5d821e1685103c520d674c450211c4cf21306937e4e48"
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
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v3.3.1/elpi.opam"
    sha256 "aca7918b921d7cd029e3d484d27ebcf2ba4eb5fea691deada7da2d8f7632e381"
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
