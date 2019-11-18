class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.12.tar.gz"
  sha256 "325f577ffccae54269289eb3134ff7b1cae2fb60a882108531e622de8f6e21de"

  bottle do
    cellar :any_skip_relocation
    sha256 "0781ad8426f33718cb8887d2ad61a8a5e5c71576f983f0b696c7be249728f33e" => :catalina
    sha256 "79dadacebd7c332387285c918538ea368721271d142aa78f144db7dfc23c60d1" => :mojave
    sha256 "9c55bf544787f37678ce9ab0e3708282a913926df7cd75cefaf660de7aa0d399" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
