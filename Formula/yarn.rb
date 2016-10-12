class Yarn < Formula
  desc "Fast, reliable, and secure dependency management for JavaScript"
  homepage "http://yarnpkg.com"
  url "https://github.com/yarnpkg/yarn/releases/download/v#{version}/yarn-v#{version}.tar.gz"
  version "0.15.0"
  sha256 "93a8083bd4989d3f7c05fcf57dfe232e00a35a09e48354b9316d2bc43f74b51b"

  def install
    bin.install "bin/yarn"
    bin.install "bin/yarn.js"
    prefix.install "package.json"
    prefix.install "node_modules"
    prefix.install "lib-legacy"
  end

  test do
    system "#{bin}/yarn", "--version"
  end
end
