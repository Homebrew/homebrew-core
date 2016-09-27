class Vimpager < Formula
  desc "Use ViM as PAGER"
  homepage "https://github.com/rkitover/vimpager"
  url "https://github.com/rkitover/vimpager/archive/2.06.tar.gz"
  sha256 "cc616d0840a6f2501704eea70de222ab662421f34b2da307e11fb62aa70bda5d"
  head "https://github.com/rkitover/vimpager.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "308c68e761983beb317bbefcba285022dbc74a66486a3da7e2ac8bc929649a3a" => :sierra
    sha256 "eccfe695299ff91b489e0385b2024e6f383426f696dc4a5462fe2e0bc6f875b1" => :el_capitan
    sha256 "be8ae8e77106e1fa95821b59171b982af74365693be0b416e41bb807a07c6c60" => :yosemite
    sha256 "4e751d2207b8925e1c229edb88a7f635d41aa611a576a1b7a9bf0b9b701df341" => :mavericks
  end

  option "with-pandoc", "Use pandoc to build and install man pages"
  depends_on "pandoc" => [:build, :optional]

  def install
    system "make", "docs" if build.with? "pandoc"
    bin.install "vimcat"
    bin.install "vimpager"
    doc.install "README.md", "vimcat.md", "vimpager.md"
    man1.install "vimcat.1", "vimpager.1" if build.with? "pandoc"
  end

  def caveats; <<-EOS.undent
    To use vimpager as your default pager, add `export PAGER=vimpager` to your
    shell configuration.
    EOS
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      This is test
    EOS

    assert_match(/This is test/, shell_output("#{bin}/vimcat test.txt"))
  end
end
