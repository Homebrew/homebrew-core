class RocqElpi < Formula
  desc "Elpi extension language for Rocq"
  homepage "https://github.com/LPCIC/coq-elpi"
  # Update resources based on https://github.com/LPCIC/coq-elpi/blob/v#{version}/rocq-elpi.opam#L18-L26
  url "https://github.com/LPCIC/coq-elpi/releases/download/v3.5.1/rocq-elpi-3.5.1.tar.gz"
  sha256 "08975c8b094c380049dfa31a1d8b32d4ea033b6d926bfa40d0164bc6d613fa46"
  license "LGPL-2.1-or-later"
  compatibility_version 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b6341394e226cdd5be3ec545b56c962226e66f9a3431a07fe8dfc0100b53a7a7"
    sha256 arm64_sequoia: "c87ad5e2360c4117466730b23d6126391b5750656a3ef2bb246f716cd564be31"
    sha256 arm64_sonoma:  "5eb26ed4b853c93324dcf45a02e21f175a3c78ad52ead536996c2765384b016e"
    sha256 arm64_linux:   "4aa189b2ce84e04f88e5e350b0dc29c1cbbf25203a09612c87f57fd1d86807f0"
    sha256 x86_64_linux:  "d3b4972263316c9f862c27d5390c15594c87b86409679081f78adf73dd725651"
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
    url "https://raw.githubusercontent.com/LPCIC/elpi/refs/tags/v3.7.3/elpi.opam"
    sha256 "c3ce914dde7fbfba6bd94ab872d65307a4d55a90c5b9fa1361573f07de8a2405"
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
