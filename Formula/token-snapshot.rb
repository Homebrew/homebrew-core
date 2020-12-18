class TokenSnapshot < Formula
  desc "Creates snapshot of ERC-20 token at specific block in CSV format"
  homepage "https://github.com/OpenFuturePlatform/token-snapshot-tool"
  url "https://github.com/OpenFuturePlatform/token-snapshot-tool/archive/v1.0.1.tar.gz"
  sha256 "ffb03e34df8fce458f32006e24845f5c3c1c85cecb1672677aef671c499b50cf"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "openjdk"

  resource "jar" do
    url "https://github.com/OpenFuturePlatform/token-snapshot-tool/releases/download/v1.0.1/snapshot-1.0.1.jar"
    sha256 "d2b4f675a9656f17dbaf99f6bb4544618484fe60dec5a56b9f6d8a6d161d066c"
  end

  def install
    libexec.install resource("jar")
    bin.write_jar_script libexec/"snapshot-#{version}.jar", "token-snapshot"
    bash_completion.install "token-snapshot-completion.sh"
  end

  test do
    system "#{bin}/token-snapshot", "--help"
  end
end
