class Ship < Formula
  desc "Deploy 3rd party applications through modern pipelines"
  homepage "https://ship.replicated.com/"
  url "https://github.com/replicatedhq/ship/releases/download/v0.21.0/ship_0.21.0_darwin_amd64.tar.gz"
  version "0.21.0"
  sha256 "31aff6c15e6b3cf964f724d5e74e4199db57954c2d7650fce03638138c04df6c"

  def install
    bin.install "ship"
  end

  test do
    system "#{bin}/ship", "version"
  end
end
