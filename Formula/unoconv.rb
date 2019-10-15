class Unoconv < Formula
  desc "Convert between any document format supported by OpenOffice"
  homepage "http://dag.wiee.rs/home-made/unoconv/"
  url "https://files.pythonhosted.org/packages/a2/b8/3131d20bfa2065e489edc7ca2dbfd66fd8d4fcbbde3476c76605a7e69269/unoconv-0.8.2.tar.gz"
  sha256 "c7091a409384c05b3509b18be6c8d7059d26f491dfa78660ecdfbde3e72b03be"
  revision 1
  head "https://github.com/dagwieers/unoconv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11e0cb4068ef96f542f2d1db62bfae1402041d22712c50624f387ebcbf9c21dd" => :catalina
    sha256 "07a0230f3b34e5d3566bf167320563d7923deb380e78c6d8380f7f2b56f0b50b" => :mojave
    sha256 "af451c29611a9fed41fb2b68984a20f80ff9a812a23c28233878ee84fb8dc208" => :high_sierra
    sha256 "af451c29611a9fed41fb2b68984a20f80ff9a812a23c28233878ee84fb8dc208" => :sierra
  end

  depends_on "python"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<~EOS
    In order to use unoconv, a copy of LibreOffice between versions 3.6.0.1 - 4.3.x must be installed.
  EOS
  end
end
