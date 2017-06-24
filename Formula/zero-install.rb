class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "http://0install.net/"
  url "https://github.com/0install/0install/archive/v2.12-1.tar.gz"
  version "2.12-1"
  sha256 "317ac6ac680d021cb475962b7f6c2bcee9c35ce7cf04ae00d72bba8113f13559"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d763e6f40daecae76c4b13fe07415b34fed02acbc0af435660cbc8366f4bae70" => :sierra
    sha256 "311457af0361373c81ba2008402a8073b4b0d20afab1cf37b4d4fc651ab31046" => :el_capitan
    sha256 "7435c7338aa470c9365a1c693fc03138496875f8781ae80f9c8f6bff1c905641" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "camlp4" => :build
  depends_on :gpg => :run
  depends_on "gtk+" => :optional

  def install
    ENV.append_path "PATH", Formula["gnupg"].opt_bin

    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    modules = %w[yojson xmlm ounit react ppx_tools lwt<3 extlib ocurl sha]
    modules << "lablgtk" if build.with? "gtk+"
    system "opam", "install", *modules

    system "opam", "config", "exec", "make"
    inreplace "dist/install.sh", '"/usr/local"', prefix
    inreplace "dist/install.sh", '"${PREFIX}/man"', man
    system "make", "install"
  end

  test do
    (testpath/"hello.py").write <<-EOS.undent
      print("hello world")
    EOS
    (testpath/"hello.xml").write <<-EOS.undent
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
