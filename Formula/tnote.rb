class Tnote < Formula
  desc "Small note-taking program for the terminal"
  homepage "http://tnote.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tnote/tnote/tnote-0.2.1/tnote-0.2.1.tar.gz"
  sha256 "451e0e352cb279725c5e12ad1c1377be63c7113f3fe568fb6213ede478ba6a87"

  bottle do
    cellar :any_skip_relocation
    sha256 "6665cd2351aff6cf025483f711b9620667a2d32e275230cb80d5d790477c5e3f" => :sierra
    sha256 "63b2c1aea236fd24d2fa5c315bd0772b009d63018b9c18379a5e782f65debfea" => :el_capitan
    sha256 "de7e2e72f85a8c42133329f77d242aa0b8a6c9cb2edbb305d843a6e7be1ea3b0" => :yosemite
    sha256 "8e3a2baf4185b131e0223e6b0fe113890ace15b6a9c67b5f7a4068b3d767c4e6" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    ENV["EDITOR"] = "/bin/cat"
    system bin/"tnote", "--nocol", "-a", "test"
  end
end
