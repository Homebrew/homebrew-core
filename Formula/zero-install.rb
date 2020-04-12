class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "https://0install.net/"
  url "https://github.com/0install/0install.git",
      :tag      => "v2.16",
      :revision => "102cbedea0bec5eaf85e48856b701ff56939cc20"
  head "https://github.com/0install/0install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfc7b1b0cdc9bb46faacb076ff3623d54ad32ed1b43d1e979d836f501c535c44" => :catalina
    sha256 "8fe6638d2b1a47bd2ef6beaf7b9de8b2389addfe939c452302534062ad42a816" => :mojave
    sha256 "446e9e57e493eaf67818e3ebc776bdc653187e89048cf76454531cf84b81b6e7" => :high_sierra
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
