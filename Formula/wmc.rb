class Wmc < Formula
  desc "Command-line loader for the WifiMCU platform"
  homepage "https://github.com/zpeters/wmc"
  url "https://github.com/zpeters/wmc/archive/v0.1.2-alpha.tar.gz"
  version "0.1.2-alpha"
  sha256 "b9d3fdc1a6a9cb4fe66081cef6d52e56d4a90a126b0dcb7e26addc6376228d8b"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    system "go", "get", "github.com/spf13/viper"
    system "go", "get", "github.com/spf13/cobra"
    system "go", "get", "github.com/tarm/serial"

    system "go", "build", "-o", "wmc"
    bin.install "wmc"
  end

  test do
    system "wmc", "config"
  end
end
