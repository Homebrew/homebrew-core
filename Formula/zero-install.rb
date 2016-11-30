class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "http://0install.net/"
  url "https://github.com/0install/0install/archive/v2.12-1.tar.gz"
  version "2.12-1"
  sha256 "317ac6ac680d021cb475962b7f6c2bcee9c35ce7cf04ae00d72bba8113f13559"

  bottle do
    cellar :any_skip_relocation
    sha256 "a171ad2ed2fda9908dadaf7e11241e2020d5dea98196be3ee0628457e8ee921a" => :sierra
    sha256 "0ce3a43128fa5b9b7feb64b0977b08b2f264dfa07abe550e7b80f952eab8d87a" => :el_capitan
    sha256 "7daacded99d0068b67623217198d56af693ffe971a34b7b24130a6c222309407" => :yosemite
    sha256 "b718f7713079f301b08aef70ac070c23aa72cba19638dfb37ff208bd9b746c86" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "camlp4" => :build
  depends_on :gpg => :run
  depends_on "gtk+" => :optional

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    modules = %w[yojson xmlm ounit react ppx_tools lwt extlib ocurl sha]
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
