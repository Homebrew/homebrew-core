require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.8.1.tgz"
  sha256 "2aa6d516fd4760e9d3f43cd5f9548f8b1a8d6b36e30dacd371468d89775ebe25"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "3e117108948c0688d7f500ae31be7d908c727abce075873d1d6ae93b59b3acee"
    sha256                               arm64_monterey: "dba136f51943a56258def2ee39aff91abd29a7fc20325346a51907ca45fffcc3"
    sha256                               arm64_big_sur:  "8fcc455840bd2c0021f7946d4d3198b3a8114ae8ebfe677288d408b44845ef1e"
    sha256                               ventura:        "08bfa075a42b07a3f8dca9b623320872566d616434ee893e8b80b2e50e21224e"
    sha256                               monterey:       "9e632a250c10fc0f665494afcc39e1ef49c38449e7b1f5b27232763e04a931db"
    sha256                               big_sur:        "b6cfe7e3d6bbe3d38d8ab3d3a8f182f7c04abb2aca6851041d636a6d19ba682b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63e4c4db12ec08b55f64640887312ab6fd6e5f17337cabff88a09661d120db1e"
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
