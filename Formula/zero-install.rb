class ZeroInstall < Formula
  desc "Zero Install is a decentralised software installation system"
  homepage "https://0install.net/"
  url "https://github.com/0install/0install.git",
      :tag      => "v2.17",
      :revision => "4a837bd638d93905b96d073c28c644894f8d4a0b"
  head "https://github.com/0install/0install.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4abf6190c3907b39ed0b4bbe28bec2ed5bb896f05e5d3764299f8d8b36c50a05" => :catalina
    sha256 "ac1f9c41269a147a6740e29458a5a760236909f3c067dc77385c8bc475455fb0" => :mojave
    sha256 "459b2330da864dc5ff43b4f171d5ac28e4135e56fe7fef3483dcef0008685e49" => :high_sierra
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
