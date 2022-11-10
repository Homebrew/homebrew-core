require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.4.tgz"
  sha256 "0a4e9f6fe23dd41fcf4a8bf7a803b595ada3e61d6ee21c26acafc5874c64347f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "2a8a4a6ce6aa28f4f516732413282c10176aaa263ca0e07c72d1530f198b697a"
    sha256                               arm64_monterey: "729b23062cf7dc57f2d0f28f929da35eec53545d0836a0164ef4b11013b79a50"
    sha256                               arm64_big_sur:  "e846d7c22c7155262b00ec8650b20b1fc7c6b2a1586ee1243b2ca7bff0c595ca"
    sha256                               monterey:       "c87da202b6e7b651815fbabf87ec57d17233c334182a8f19353b19df9d5e3801"
    sha256                               big_sur:        "08f66e303da4cb46c3a5a7d7c3cbc8285f80e06b3e094e50a509e6f8f193ef1b"
    sha256                               catalina:       "d8d940e6b00bf38d0a0c562034b72dc0db05a8e8c1849c532da50498b60e0dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0cea048a158e3b3f518766bf2a051f1b6968bdb54da992a57a2d931144d6335"
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
    truffle_dir.glob("node_modules/ganache/dist/node/*.node").each do |f|
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
