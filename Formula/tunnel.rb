class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  bottle do
    cellar :any_skip_relocation
    sha256 "7135b88f2141bf0c7219d6be3017d75780c2ae2840a7b968327ccf3df8c11664" => :catalina
    sha256 "a598e1baf67a2e824b0d0db255c5b59279d7d3f6d05adfe135b382f68c2a3eab" => :mojave
    sha256 "71758e150eef0eb5d826abaa3985332fbee0fd1b8ddb128ea1913c43df7b17de" => :high_sierra
    sha256 "9368538e7827ba06f7dad1aeece19833f721e78883eade09d83dd72bc71f3de1" => :sierra
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
