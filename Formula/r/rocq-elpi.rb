class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v3.4.0/rocq-elpi-3.4.0.tar.gz"
  sha256 "fe81750ca2e5f5976f16e658979a133cfaa2011ae5591e552a1222ceaacaaf06"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e22b2c7d81a1ed30f614617ca71191b350601ab0021f3d606fc9954f097d98b6"
    sha256 arm64_sequoia: "e65ad42499e74fdd7ac0403f74d6ee8091e5658d9e9df9598500030d2c3e54e9"
    sha256 arm64_sonoma:  "a712db4a0dade91fb8b3ab75023039eea4494962a3e23c1fa1c3339f1884d1c4"
    sha256 sonoma:        "050510bbd4de6dd6a4d40b83c36a12468b909dee2020afa201329b7ed64a7c3a"
    sha256 arm64_linux:   "5fe352222f9b28770577fbe6050ed1ef77c89d4f3911ac39dfe8bd70fd5f56ba"
    sha256 x86_64_linux:  "261f2351f4d99f767563d14a142317e7241519ed0292726e76201319796527c1"
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
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v3.7.1/elpi.opam"
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

    # dune 3.24 replaced the Coq build language with the Rocq build language.
    dune_files = buildpath.glob("**/dune") << (buildpath/"dune-project")
    {
      "(lang dune 3.13)" => "(lang dune 3.24)",
      "(using coq 0.8)"  => "(using rocq 0.11)",
      "(coq (flags"      => "(rocq (flags",
      "coq.theory"       => "rocq.theory",
      "coq.pp"           => "rocq.pp",
      "%{coq:"           => "%{rocq:",
    }.each do |before, after|
      inreplace dune_files.select { |f| f.read.include?(before) }, before, after
    end

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
