class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.40.tar.gz"
  sha256 "1363d48c32c4bb528514abf012ae0a61e7c686504a047ce870e72e791447c3d1"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88a5d4653d7062e0ac6d9913d35390126c1739fe04f0f458624f0199046d0fcd" => :catalina
    sha256 "18c0460162e7dcb98d499fb8622a471162897a91f4f844fe46f42a52182cc69e" => :mojave
    sha256 "a0623fd31e458f82217956bd98e72964634f5d632025336386e824a27fe654ae" => :high_sierra
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
