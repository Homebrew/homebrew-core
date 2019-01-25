class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.6.3.tar.gz"
  sha256 "12b4e79495f5bb091c19e601d8af5c06574e680a621d015dac9f6b8357ee901a"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fe6aea188e275538ef94f6269905f6a9e44f535f2c63e01f42ce9fd5ae7f68d" => :mojave
    sha256 "dcaad69f03436f226678772d488b64f348cf213984184149ef9625882b15a191" => :high_sierra
    sha256 "eaedb240663d468c05b04e1b2fcccec1500950db8c21622e8f217f8e7cadcdde" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "mvdan.cc/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
