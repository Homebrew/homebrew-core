class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "https://0install.net/"
  url "https://github.com/0install/0install.git",
      :tag      => "v2.15.2",
      :revision => "643ec4be53566d09d4bebd19339beebcc3ff8acc"
  head "https://github.com/0install/0install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "670a096307222ef611ea885ac9c1389ffe34c69a220def618e22f14941113737" => :catalina
    sha256 "a77fcd995618cefc919fd89e38b644be27618c89120f2296555be21674776ec4" => :mojave
    sha256 "a699dbf8f06b7f392c8dd5cb28c8e24ed6ca6f7aff51226d3abf72afdcc53e53" => :high_sierra
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "gnupg"

  def install
    ENV.append_path "PATH", Formula["gnupg"].opt_bin

    # Use correct curl headers
    ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version) if MacOS.version >= :mojave && MacOS::CLT.installed?

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      modules = %w[
        yojson
        xmlm
        ounit
        lwt_react
        ocurl
        sha
        dune
      ]
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
