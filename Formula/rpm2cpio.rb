class Rpm2cpio < Formula
  desc "Tool to convert RPM package to CPIO archive"
  homepage "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/"
  url "https://svnweb.freebsd.org/ports/head/archivers/rpm2cpio/files/rpm2cpio?revision=408590&view=co"
  version "1.4"
  sha256 "2841bacdadde2a9225ca387c52259d6007762815468f621253ebb537d6636a00"

  bottle do
    cellar :any_skip_relocation
    sha256 "8655ba73b79595a55d289c2c969e027f2034c0af88263f9fa8c5cb8a1184a823" => :catalina
    sha256 "081902485154a2061d890e6421a55d15bfe5072c05109c79e0ef50f2a11b96e5" => :mojave
    sha256 "804dccff2726a9ac18a1002cd8adb06aacd07ce1fff93b995c042d4e78775176" => :high_sierra
    sha256 "05f2a6011c554efb2c2196fdf08bfc6f7c6fd6d4e32530399888aabcc73ca339" => :sierra
  end

  depends_on "xz"

  def install
    bin.install "rpm2cpio?revision=408590&view=co" => "rpm2cpio"
  end
end
