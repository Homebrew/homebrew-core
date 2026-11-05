class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v3.6.0/rocq-elpi-3.6.0.tar.gz"
  sha256 "72ecf7a08edf8ebbe9114df8d27ab0d272b8682d2f68297b6f6730f8ad429abb"
  license "LGPL-2.1-or-later"
  compatibility_version 5

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "95a73100081df0c3399c5c0d7e2896e5e4b568e25b5ce121bb99b039b5c59d8b"
    sha256 arm64_tahoe:       "9a3fbab480f89a79324a380eaba49ed9baaedf47f18879b702a473a9ae2ff127"
    sha256 arm64_sequoia:     "007ae843309d48dad542a20cee7af58fb60358cedb90b0faf2efa418fccb2eb4"
    sha256 arm64_linux:       "3d505203c0b0e278a083e5a864805736d86021716b897f6ee4208d1f1f3343a6"
    sha256 x86_64_linux:      "c606449b6633e2175fb59161d930541e4ddde85214a8e8e9739856551b4c07ce"
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
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v4.0.0/elpi.opam"
    sha256 "9b42f3ce82465cc827d32745467ca106b8053d57d05ce10bc001ae134cf7e142"
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

    # `ocamlfind` 1.9.9 writes relative paths, which resolve against the working
    # directory rather than the switch.
    inreplace libexec/"ocaml-system/lib/findlib.conf" do |s|
      s.gsub!(/^destdir=.*/, "destdir=\"#{libexec}/lib\"")
      s.gsub!(/^path=.*/, "path=\"#{HOMEBREW_PREFIX}/lib/ocaml:#{libexec}/lib\"")
    end

    ENV["OCAMLFIND_CONF"] = libexec/"lib/findlib.conf"

    # dune 3.24 replaced the Coq build language with the Rocq build language.
    dune_files = buildpath.glob("**/{dune,dune-project}")
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
    assert_equal <<~TEXT, shell_output("#{formula_opt_bin("rocq")}/rocq compile example_data_base.v")
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
