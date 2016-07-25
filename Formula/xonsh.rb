class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.4.4.tar.gz"
  sha256 "c029b831615ea4f5f032172c10bb08c472ceda669fa119e190233e045ea434d3"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd2d818066ffc5c1ab6bf650c0a678879d1eb7027846de7c2d57359944eea767" => :el_capitan
    sha256 "fddc95ffaa18123dcf8601caf3393cc41b015e4caa89ef5e32d00ef7aa7c8cb8" => :yosemite
    sha256 "ca5e7b8e4e0af43fbf0a695285fa2a2903d363b30cc347cad6803b5299a2b95b" => :mavericks
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/96/e0/430fcdb6b3ef1ae534d231397bee7e9304be14a47a267e82ebcb3323d0b5/ply-3.8.tar.gz"
    sha256 "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resource("ply").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
