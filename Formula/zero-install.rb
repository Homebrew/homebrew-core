class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "http://0install.net/"
  url "https://github.com/0install/0install/archive/v2.12-1.tar.gz"
  version "2.12-1"
  sha256 "317ac6ac680d021cb475962b7f6c2bcee9c35ce7cf04ae00d72bba8113f13559"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "d9e36284d013ef7da8b42ff9c2552433518e527d77c041a9db22aebc49d3b078" => :high_sierra
    sha256 "bf4bb4e75194ac7f85969298f592fa460c459fe5363aaca290c16055cbb6be91" => :sierra
    sha256 "fc20a07f9e2f81feeeb0b755838b5e6f327206f9a95c00f13b7fcea851c00199" => :el_capitan
    sha256 "173371c177694ff72038f504c81bde55777960d14678bf1d0b942487aff444ef" => :yosemite
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
