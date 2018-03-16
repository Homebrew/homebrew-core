class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "http://0install.net/"
  url "https://github.com/0install/0install/archive/v2.12-1.tar.gz"
  version "2.12-1"
  sha256 "317ac6ac680d021cb475962b7f6c2bcee9c35ce7cf04ae00d72bba8113f13559"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "5a736e35a617a5c234f7d8ba42a20c4add1af4243a03a44c69555fe4047ce6ae" => :high_sierra
    sha256 "e1f05fd470aba09720acfa93b2b32523d9124816d28adc09bd890464c1f4062f" => :sierra
    sha256 "9296e314e4d685afa1df4306f086af9fe6de208889f6d6014261207ea55899c2" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "camlp4" => :build
  depends_on "gnupg"
  depends_on "gtk+" => :optional

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat
    ENV.append_path "PATH", Formula["gnupg"].opt_bin

    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    modules = %w[yojson xmlm ounit react ppx_tools lwt<3 extlib ocurl sha]
    modules << "lablgtk" if build.with? "gtk+"
    system "opam", "config", "exec", "opam", "install", *modules

    system "opam", "config", "exec", "make"
    inreplace "dist/install.sh", '"/usr/local"', prefix
    inreplace "dist/install.sh", '"${PREFIX}/man"', man
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
