class Vaulted < Formula
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "22d05131f6d6cf2e66b65e7c0ba9862142312723e854063e3f3b8414cdedafbb"

  head "https://github.com/miquella/vaulted"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "github.com/bgentry/speakeasy"
    system "go", "get", "github.com/miquella/vaulted/vault"

    #Build and install Vaulted
    system "go", "build", "-o", "vaulted"
    bin.install "vaulted"
  end
end
