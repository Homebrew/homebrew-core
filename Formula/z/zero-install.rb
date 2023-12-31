class ZeroInstall < Formula
  desc "Decentralised cross-platform software installation system"
  homepage "https://0install.net/"
  url "https://github.com/0install/0install.git",
      tag:      "v2.18",
      revision: "b58af5db6afd496cfd4a5f85fb23f30ba8dfbc87"
  license "LGPL-2.1-or-later"
  head "https://github.com/0install/0install.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b751e193e9b5105e46de557b3d09b57dac2e36457358c66d5af441955c98b6b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29193da44165014972823b152963e10f4b016964418842bf24e944d9e29d47ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e681ef011946eee260f580f0faaf250803ffe7df97875db1560f24d26de68e44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba5899e357c4e98c2116230eee9cad756f51564250471b950503f936f5951306"
    sha256 cellar: :any_skip_relocation, sonoma:         "813a1b599f5fc67cab8418cd70ddf64a0c7c8f62e78520cb221bf58ea0a54df8"
    sha256 cellar: :any_skip_relocation, ventura:        "66092ce622c03dda83c74e9d4c92c2241cc43485001c70885450ff0bcc8476f4"
    sha256 cellar: :any_skip_relocation, monterey:       "f293e6e5c07b33cebf63f868e2582e3dc390c0e2305fcefb7e7b17c5eb6d57fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f4761b5bf5adce56f3a0084b110aa51026cdbd85a152112481484a30878a13b"
    sha256 cellar: :any_skip_relocation, catalina:       "66a2d596f829de3bab7abf5558b0c4e9e922983ee146930b3755c38f4a593e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc1fe5759e42d2757f7ab28cdd33eecc9339ef83bf8aebb60cba6d8b5dd94d6"
  end

  depends_on "ocaml" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build
  depends_on "gnupg"

  uses_from_macos "python" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config"
  end

  def install
    ENV.append_path "PATH", Formula["gnupg"].opt_bin

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
