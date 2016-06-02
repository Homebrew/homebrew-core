class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/scopatz/xonsh/archive/0.3.2.tar.gz"
  sha256 "2c140d04b01b95605608836faf0aae2e3d65b89145748240e07cd7506c5107f8"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52ce3bfeabc89a1aa023c0e437f698fa4683fb3bfc23d8bec405c167073a9547" => :el_capitan
    sha256 "de0b07c1917580d703c3a68a683e3280fa3fb76e97cff372efce457ab499c3d1" => :yosemite
    sha256 "88a7e0471e040fc25be666741f75e695be797f8fbacbdd049c4c9cf508c72742" => :mavericks
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
