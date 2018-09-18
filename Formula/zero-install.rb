class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "https://0install.net/"
  url "https://downloads.sourceforge.net/project/zero-install/0install/2.13/0install-2.13.tar.bz2"
  sha256 "10726e05ac262c7c5dd1ae109deddf9aa61a146db8fc75c997dd4efc3a4d35ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "12d16e6e7c193b0525bf783a931e178a43cb2357a6821de8628d5b1945e5b8c0" => :mojave
    sha256 "29434cfb80b552cb133e47b6a0a8e4d9929656de096c6fb383ab53dae9d6af5a" => :high_sierra
    sha256 "5e6a18d83dc1503a71545506b25de4b0c97efbdf0a4ce6632a30369bc96e0cc2" => :sierra
    sha256 "0fa494c5e2852f8ebcadadc9c441302145444da6f580efce516263f9c1b33e4f" => :el_capitan
  end

  depends_on "camlp4" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "gnupg"
  depends_on "gtk+" => :optional

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat
    ENV.append_path "PATH", Formula["gnupg"].opt_bin

    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    modules = %w[
      cppo
      yojson
      xmlm
      ounit
      lwt_react
      ocurl
      obus
      sha
      cppo_ocamlbuild
    ]
    modules << "lablgtk" << "lwt_glib" if build.with? "gtk+"
    system "opam", "config", "exec", "opam", "install", *modules

    # mkdir: <buildpath>/build: File exists.
    # https://github.com/0install/0install/issues/87
    ENV.deparallelize { system "opam", "config", "exec", "make" }

    inreplace "dist/install.sh" do |s|
      s.gsub! '"/usr/local"', prefix
      s.gsub! '"${PREFIX}/man"', man
    end
    system "make", "install"
  end

  test do
    (testpath/"hello.py").write <<~EOS
      print("hello world")
    EOS
    (testpath/"hello.xml").write <<~EOS
      <?xml version="1.0" ?>
      <interface xmlns="http://zero-install.sourceforge.net/2004/injector/interface">
        <name>Hello</name>
        <summary>minimal demonstration program</summary>

        <implementation id="." version="0.1-pre">
          <command name='run' path='hello.py'>
            <runner interface='http://repo.roscidus.com/python/python'></runner>
          </command>
        </implementation>
      </interface>
    EOS
    assert_equal "hello world\n", shell_output("#{bin}/0launch --console hello.xml")
  end
end
