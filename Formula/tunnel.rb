class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.4.0.tar.gz"
  sha256 "a428133da9d20aafd17fa3a3f067a0ad9add62852a5e76a8c6c9f675730c86d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb59b08714760f8c0700df546de4211f881769fadafd31fc1df3ba173b9ecddf" => :mojave
    sha256 "60f4fe537955f4290bfad66fe86280291adbd930663317e8ec95af5703eb715b" => :high_sierra
    sha256 "542b9b72465f423656d687534af0b25c468f62c97d0531e34d15abb533cd51d9" => :sierra
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
