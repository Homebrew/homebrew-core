class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms-clients/archive/v3.0.7.tar.gz"
  sha256 "24cc29f4dc93f048e1cda9003ab8004e5d0ebc245d0139a058e6224bc2ca6ba7"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc3c2980b8816b23d01c8f9b0db3b47c27c1ab26572465c8867baad452ad4035" => :mojave
    sha256 "50f51cebb89971280072db95e7674a2ace3363ad11e7fb39654411d240f9067c" => :high_sierra
    sha256 "247e6715cfaa6511762096465e7d32c1b3cc729a78833c7a033d6df62a952789" => :sierra
    sha256 "2c714e700a020e728425fcacfb2d4217bbbfcbf2ccb5e62fa2d723dd4d4c4fd2" => :el_capitan
    sha256 "9afed6217d4abdaf71419b4cdab29599244962891ccdd600e53ad2454f6b3191" => :yosemite
    sha256 "7f8dc56553a8b31c5080ef32493ee1d509b4945c7493a16fa9def20daed57d54" => :mavericks
  end

  depends_on "maven" => :build
  depends_on :java
  depends_on "openssl"

  def install
    system "mvn", "package", "-Dmaven.repo.local=$(pwd)/m2repo/", "-Dmaven.javadoc.skip=true"
    system "tar", "-xf", "target/voms-clients.tar.gz"
    share.install "voms-clients/share/java"
    man5.install Dir["voms-clients/share/man/man5/*.5"]
    man1.install Dir["voms-clients/share/man/man1/*.1"]
    bin.install Dir["voms-clients/bin/*"]
  end

  test do
    system "#{bin}/voms-proxy-info", "--version"
  end
end
