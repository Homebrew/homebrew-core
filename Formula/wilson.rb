class Wilson < Formula
  desc "Wilson - developer's routine tasks automation toolkit. Simple modern alternative to GNU Make 🧰"
  homepage "https://github.com/trntv/wilson"
  url "https://github.com/trntv/wilson/releases/download/0.3.1/wilson-darwin-amd64.tar.gz"
  sha256 "5e428579afbc4005b3730d34f3166f8b27c738bade2e95c49ec465120c0c307a"
  version "0.3.1"

  def install
    bin.install "wilson_darwin_amd64" => "wilson"
  end

  test do
    system "#{bin}/wilson", "--version"
  end
end
