class RocqElpi < Formula
  desc "Elpi extension language for Coq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v2.5.0/rocq-elpi-2.5.0.tar.gz"
  sha256 "0352cee8fc0a0224f8d8043d7c0f4daf217842e0dc46d5795537bdec737006ae"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
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
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v2.0.7/elpi.opam"
    sha256 "25a4d6bafd404d6067bd95227e7bd29de82d887f3789ac80ade7489b995edc1f"
  end

  resource "ppx_optcomp" do
    url "https://raw.githubusercontent.com/janestreet/ppx_optcomp/refs/tags/v0.17.0/ppx_optcomp.opam"
    sha256 "9ddda7e28dabea043a0187acf3d0ff378084e0ef75c9e2003bd0350b83f4dd41"
  end

  def install
    with_env(OPAMROOT: buildpath/".opam", OPAMYES: "1", OPAMNODEPEXTS: "1", OPAMNOSELFUPGRADE: "1") do
      system "opam", "init", "--disable-sandboxing", "--no-setup"
      system "opam", "install", "elpi.#{resource("elpi").version}", "ppx_optcomp.v#{resource("ppx_optcomp").version}"
    end

    # Move packages needed at runtime into libexec
    libexec.install buildpath.glob(".opam/default/*")
    inreplace [libexec/"lib/findlib.conf", libexec/"lib/toplevel/topfind"], buildpath/".opam/default", libexec

    # Replace findlib package with formula
    inreplace libexec/"lib/toplevel/topfind", libexec/"lib/findlib", Formula["ocaml-findlib"].opt_lib/"ocaml/findlib"
    rm_r(libexec/"lib/findlib")

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
      Rocq needs the path to ML files installed inside `#{opt_libexec}/lib`.
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
    assert_equal <<~EOS, shell_output("#{Formula["rocq"].bin}/rocq compile example_data_base.v")
      The Db contains [phone_prefix USA 1]
      Phone prefix for USA is 1
      The Db contains#{space}
      [phone_prefix USA 1, phone_prefix France 33, phone_prefix Italy 39]
      Phone prefix for France is 33
      sweet!
      brr
      yummy!
    EOS
  end
end
