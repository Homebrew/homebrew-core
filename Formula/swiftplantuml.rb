class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://github.com/MarcoEidinger/SwiftPlantUML"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/0.7.5.tar.gz"
  sha256 "6aa92d4e9ee30a761755ac908b3196226af7212a509986367d738c2b53af5eac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25d86064cb1f2d5a440a91bb8dc19587decadd1de70c150e1adfd597d7695c89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c9358c089cc3d8150c93af4aea7d9edafbaad7f47104466e95d91c2b62512df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23be791f6d63cec4346241ece67f4eae5861cfe42eec9b61b490872ed53eed72"
    sha256 cellar: :any_skip_relocation, ventura:        "0cb0e9a5ec594356682697e53795d296b081596aef85058ca5b3c398043c89ca"
    sha256 cellar: :any_skip_relocation, monterey:       "e37cd1d75df07d7a51c0093be57ae885913c30a686a6dda374ea92fa6ea01374"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7efd073910a23b71f8795551a894ed140102f2d6fc38debd9ae2f854cbd841b"
  end

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/swiftplantuml", "--help"
  end
end
