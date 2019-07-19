class Zenio < Formula
  desc "CLI Zenio Tool"
  homepage "https://dev.zenio.co"
  url "https://dev.zenio.co/cli/zenio-0.9.0-SNAPSHOT.tar"
  sha256 "1c8678ad5aa332f0e19a7db91e9bd4bfc04f62989302605c6243569e0eea5231"

  depends_on :java

  def install
    inreplace "zenio", "##PREFIX##", prefix
    inreplace "zenio", "##VERSION##", "0.9.0-SNAPSHOT-all"
    prefix.install "zenio-0.9.0-SNAPSHOT-all.jar"
    bin.install "zenio"
  end

  test do
    system "#{bin}/zenio", "version"
  end
end
