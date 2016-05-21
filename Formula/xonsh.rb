class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/scopatz/xonsh/archive/0.3.0.tar.gz"
  sha256 "6553d95f1e52a664a5b15ff096ecf09d9d970d18dfd7bd577ad1132e7348bbca"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08fc79e113e059e902540678cf874dda98659d3ed57663dab240147bb86a3ac9" => :el_capitan
    sha256 "b0c4f7e69ced4119a24f872b0c09246c5201274b58d09e35b72ff3ac944f4f9e" => :yosemite
    sha256 "d0836b6671f71947804c027e1771600f24c565f96a80effdfa029ac10e075538" => :mavericks
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/source/p/ply/ply-3.8.tar.gz"
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
