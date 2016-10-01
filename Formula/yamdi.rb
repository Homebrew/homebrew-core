class Yamdi < Formula
  desc "Add metadata to Flash video"
  homepage "http://yamdi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz"
  sha256 "4a6630f27f6c22bcd95982bf3357747d19f40bd98297a569e9c77468b756f715"

  bottle do
    cellar :any_skip_relocation
    sha256 "546a4c5400ef75431ecd3a39dbabda5e5599d82ac3f65f6dafc5d3745a90d8e2" => :sierra
    sha256 "cfaf451a985b0a8cba24a0131c8e0e9a6102eb4b6c315e045ce258999cb19494" => :el_capitan
    sha256 "7041c6dcf877e8e003e2acae68a75ae6a461e92df63fde374157884b52cf2d82" => :yosemite
    sha256 "f0a2a40d6667893a51fb5082a3c09685b688a06df2df8d8b42c350c1dd0f6e16" => :mavericks
  end

  def install
    system "#{ENV.cc} #{ENV.cflags} yamdi.c -o yamdi"
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end
