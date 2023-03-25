class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.0.0/tt-1.0.0-complete.tar.gz"
  sha256 "6f42d30b9d9f9fbad1907a49cf3394f71c2c86e3faa1194fd9372e4d8877c792"
  license "BSD-2-Clause"

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
  end

  test do
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-dst", testpath
    assert_predicate testpath/"st/cartridge_app/init.lua", :exist?
  end
end
