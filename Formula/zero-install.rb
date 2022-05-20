class ZeroInstall < Formula
  desc "Decentralised cross-platform software installation system"
  homepage "https://0install.net/"
  url "https://github.com/0install/0install.git",
      tag:      "v2.17",
      revision: "4a837bd638d93905b96d073c28c644894f8d4a0b"
  license "LGPL-2.1-or-later"
  head "https://github.com/0install/0install.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6254ca486e396289cefdcd992373295aff86bfa3353aa7c5b6252aea899e92c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a6dccd6f31bdb194e16e0c24a203055cea85d48ee5fc7b955db52d788056392"
    sha256 cellar: :any_skip_relocation, monterey:       "f0d03c94152415456e3125f3fb281020b1e213253ddf79db6b4f68722d30132b"
    sha256 cellar: :any_skip_relocation, big_sur:        "77fe4b65401743e8cd82de23568ad9e630e50467018faba2b7167231fe14f48a"
    sha256 cellar: :any_skip_relocation, catalina:       "4306ae5d0ca339a7f5ecd9c7ba6a3a192a1d176883d49dda9d31aad78bc390fd"
    sha256 cellar: :any_skip_relocation, mojave:         "73b04cd9560f78c799599fc4f9fba0de2b072c56e2195ef0522bb23e6eeb376b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4fb5867d432bd3e22525b95682521a12a3279dd4fb7f8b0df3cb6664a6959835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6865140889715cceb51faee115bece7448c6cc3e6f880534e7b7da92f75a1b7"
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gnupg"

  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config"
  end

  def install
    ENV.append_path "PATH", Formula["gnupg"].opt_bin

    # Use correct curl headers
    ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version) if MacOS.version >= :mojave && MacOS::CLT.installed?

    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      ENV["OPAMVERBOSE"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      # Tell opam not to try to install external dependencies
      system "opam", "option", "depext=false"
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
    (testpath/"hello.sh").write <<~EOS
      #!/bin/sh
      echo "hello world"
    EOS
    chmod 0755, testpath/"hello.sh"
    (testpath/"hello.xml").write <<~EOS
      <?xml version="1.0" ?>
      <interface xmlns="http://zero-install.sourceforge.net/2004/injector/interface" xmlns:compile="http://zero-install.sourceforge.net/2006/namespaces/0compile">
        <name>hello-bash</name>
        <summary>template source package for a bash program</summary>
        <description>This package demonstrates how to create a simple program that uses bash.</description>

        <group>
          <implementation id="." version="0.1-pre" compile:min-version='1.1'>
            <command name='run' path='hello.sh'></command>
          </implementation>
        </group>
      </interface>
    EOS
    assert_equal "hello world\n", shell_output("#{bin}/0launch --console hello.xml")
  end
end
