class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.1.tar.gz"
  sha256 "2547bd5c4c7dceb1d46c2a52cf1f9a52f6b31cb3797d94e74809b83e903e236f"

  bottle do
    cellar :any_skip_relocation
    sha256 "10c575c457a65d15218563406284d435dd04211e6ac2357031b7f72b124a2691" => :catalina
    sha256 "dbacc9ba404152f9dcdb61d37a45f91773166a7b9695e8fbaeab8f9d5b51a53c" => :mojave
    sha256 "dc81e6a2509d8f936c9ea0e0027450d35f8bfa1961b52e98af6e43eeeb6b3926" => :high_sierra
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
