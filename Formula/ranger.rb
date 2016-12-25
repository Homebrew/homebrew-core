class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.8.0.tar.gz"
  sha256 "ce02476cb93d51b901eb6f5f0fc9675c58bd0a2f11d2ce0cdb667e15ec314092"

  head "git://git.savannah.nongnu.org/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a894e9cb492bcbd0b172fc1a3693b0bac4e1ba641a9389dc3b0879f1d2d5ee5" => :sierra
    sha256 "82eb23ac75480e1f83087dd04e6d537c5b141e35de922729f8b83e0cdcdd45aa" => :el_capitan
    sha256 "8592a7b7af5b59932b01c685afaa53173a11efcead0526e30464467f944d649c" => :yosemite
    sha256 "cf9b172937e85e6a4bcfca8508378fcaf9aa81fdf18df0a3cab531cc3f27cc2a" => :mavericks
  end

  # requires 2.6 or newer; Leopard comes with 2.5
  depends_on :python if MacOS.version <= :leopard

  def install
    if MacOS.version <= :leopard
      inreplace %w[ranger.py ranger/ext/rifle.py],
        "#!/usr/bin/python", "#!#{PythonRequirement.new.which_python}"
    end

    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger --version")
  end
end
