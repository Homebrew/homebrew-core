class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.8.1.tar.gz"
  sha256 "1433f9f9958b104c97d4b23ab77a2ac37d3f98b826437b941052a55c01c721b4"

  head "git://git.savannah.nongnu.org/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53183d431e6bcf9cf49a462130fb5e0929a4bf557a2d109c354e3194bfd36cc0" => :sierra
    sha256 "224dce8bf10cb4f29a182e00d8a684a388f5dc1544f427149ee85e050c07a833" => :el_capitan
    sha256 "224dce8bf10cb4f29a182e00d8a684a388f5dc1544f427149ee85e050c07a833" => :yosemite
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
