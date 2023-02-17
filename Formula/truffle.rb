require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.7.tgz"
  sha256 "552b930012e4e2adfdd97343f3e74ae57766f793dc27a6ca9c8cd119e8bf67cd"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "7b6698a2f75a86bd173e1380238b6d1f59491f3cbdd04ffe58b6e2132c7abf87"
    sha256                               arm64_monterey: "fd7dc54ca3fca600a35a4db60f6440189c707b7c0c77475a41771fc826b830f7"
    sha256                               arm64_big_sur:  "e0cf504bdd04c676afe7194ca0406af1f7b17f9661c6f52452e6824eca57b522"
    sha256                               ventura:        "3d36942208a477da29004b61ce7aecca57729bc9ddf23f3c5a28264b581fe80c"
    sha256                               monterey:       "daeb9d1f1c3a99a3709ec887a5740d4b685da94894a787b289aff643108d3b80"
    sha256                               big_sur:        "1c4fc7170ff782be5504306d63da732a21d7c589989d7edd8e328a42df93f1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4c55782b7e84969715a596c0748d0bcebcd8ebd030786c5fa4a28cb650bd27"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    truffle_dir = libexec/"lib/node_modules/truffle"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    %w[
      **/node_modules/*
      node_modules/ganache/node_modules/@trufflesuite/bigint-buffer
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/prebuilds/*").each do |dir|
        if OS.mac? && dir.basename.to_s == "darwin-x64+arm64"
          # Replace universal binaries with their native slices
          deuniversalize_machos dir/"node.napi.node"
        else
          # Remove incompatible pre-built binaries
          dir.glob("*.musl.node").map(&:unlink)
          dir.rmtree if dir.basename.to_s != "#{os}-#{arch}"
        end
      end
    end

    # Replace remaining universal binaries with their native slices
    deuniversalize_machos truffle_dir/"node_modules/fsevents/fsevents.node"

    # Remove incompatible pre-built binaries that have arbitrary names
    truffle_dir.glob("node_modules/ganache/dist/node{/,/F/}*.node").each do |f|
      next unless f.dylib?
      next if f.arch == Hardware::CPU.arch
      next if OS.mac? && f.archs.include?(Hardware::CPU.arch)

      f.unlink
    end
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
