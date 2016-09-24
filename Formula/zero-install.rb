class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "http://0install.net/"
  # This is a fairly nasty hack to avoid backporting 10k+ lines of
  # changes in patch format. It should be reverted to use the SF tarball
  # as pointed to on the upstream website on next release.
  # One of the resources, lwt, was updated in an incompatible way,
  # but the older versions of lwt no longer support the ocaml Homebrew
  # ships since May 5th 2016. Upstream pushed changes to fix this
  # but those haven't made it into a stable release yet.
  # There's also a build fix for Ocaml 4.03.0 not in latest release.
  url "https://github.com/0install/0install.git",
      :revision => "5ec4a9f55ba8e38b60cceeef5da982847395928c"
  version "2.11"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ce3a43128fa5b9b7feb64b0977b08b2f264dfa07abe550e7b80f952eab8d87a" => :el_capitan
    sha256 "7daacded99d0068b67623217198d56af693ffe971a34b7b24130a6c222309407" => :yosemite
    sha256 "b718f7713079f301b08aef70ac070c23aa72cba19638dfb37ff208bd9b746c86" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "camlp4" => :build
  depends_on "gtk+" => :optional
  depends_on :gpg => :run

  resource "easy-format" do # [required by yojson]
    url "https://github.com/mjambon/easy-format/archive/v1.2.0.tar.gz"
    sha256 "a288fabcdc19c2262e76cf93e0fd987fe1b21493edd13309522fbae405329ffd"
  end

  resource "biniou" do # [required by yojson]
    url "http://mjambon.com/releases/biniou/biniou-1.0.9.tar.gz"
    sha256 "eb47c48f61b169e652629e7f2ee582dfd5965e640ee51bf28fab63b960864392"
  end

  resource "cppo" do # [required by yojson]
    url "https://github.com/mjambon/cppo/archive/v1.3.2.tar.gz"
    sha256 "c49e3080b3326466c7ddd97100c63bd568301802b3e48cebea3406e1ca76ebc8"
  end

  resource "yojson" do
    url "https://github.com/mjambon/yojson/archive/v1.3.2.tar.gz"
    sha256 "eff510621efd6dcfb86b65eaf1d4d6f3b9b680143d88e652b6f14072523a2351"
  end

  resource "xmlm" do
    url "http://erratique.ch/software/xmlm/releases/xmlm-1.2.0.tbz"
    sha256 "d012018af5d1948f65404e1cc811ae0eab563b23006416f79b6ffc627966dccb"
  end

  resource "ounit" do
    url "https://forge.ocamlcore.org/frs/download.php/1258/ounit-2.0.0.tar.gz"
    sha256 "4d4a05b20c39c60d7486fb7a90eb4c5c08e8c9862360b5938b97a09e9bd21d85"
  end

  resource "react" do
    url "http://erratique.ch/software/react/releases/react-1.2.0.tbz"
    sha256 "887aaea9191870bc0f37f945c02ec4c90497d949cd4dedc3d565c3fbec7ad04e"
  end

  resource "ppx_tools" do # [required by lwt]
    url "https://github.com/alainfrisch/ppx_tools/archive/5.0+4.03.0.tar.gz"
    sha256 "2cd990ef36145c35b0fd2cfaadc379cf032dd0987c07bea094d4437277d573e5"
  end

  resource "lwt" do
    url "https://github.com/ocsigen/lwt/archive/2.5.2.tar.gz"
    sha256 "b319514cf51656780a8f609a63ead08d3052a442546b218530ce146d37bf6331"
  end

  resource "extlib" do
    url "https://github.com/ygrek/ocaml-extlib/archive/1.7.0.tar.gz"
    sha256 "3c9fd159a4ec401559905f96e578317a4933452ced9a7f3a4f89f9c7130d9a63"
  end

  resource "ocurl" do
    url "http://ygrek.org.ua/p/release/ocurl/ocurl-0.7.7.tar.gz"
    sha256 "79805776f207ae8e64d63cda63d0bf8c6ee079c70b0d7f3bd2114faba0d5f41c"
  end

  resource "lablgtk" do
    url "https://forge.ocamlcore.org/frs/download.php/1602/lablgtk-2.18.4.tar.gz"
    sha256 "b316ae0b92e760c1ab0d1bdeaa0a3c2a6ab14face5a0fe2b93445be3a3d013c0"
  end

  resource "sha" do
    url "https://github.com/vincenthz/ocaml-sha/archive/ocaml-sha-v1.9.tar.gz"
    sha256 "caa1dd9071c2c56ca180061bb8e1824ac3b5e83de8ec4ed197275006c2a088d0"
  end

  def install
    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    archives = opamroot/"repo/default/archives"
    modules = []
    resources.each do |r|
      next if build.without?("gtk+") && r.name == "lablgtk"
      r.verify_download_integrity(r.fetch)
      original_name = File.basename(r.url)
      cp r.cached_download, archives/original_name
      modules << "#{r.name}=#{r.version}"
    end
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
