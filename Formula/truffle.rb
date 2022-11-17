require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.6.tgz"
  sha256 "a63b8d61c0a8e0a2e3c1748129632fa650a15ccf77a6e71834ba0e41b0f952ce"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "13051f65f409d79d4f3d49e89d8dd79a1be689357008435d7ccdae831103d9fb"
    sha256                               arm64_monterey: "35048616f3efe0a52aa08bb79a5f9262c01c176a19e4e3bf828257a66461982c"
    sha256                               arm64_big_sur:  "3ef19991d5c004ebd2036b1e571c2fc99751c7e735b989e4ffd3a92fd22303d6"
    sha256                               monterey:       "956e0bb931b5c98ea7307bf192efbd5984ceeb98e20085bc78c8d8e5dfecaeeb"
    sha256                               big_sur:        "30b6c98dfd27a0e963ef079cf24484a7a920fdb120491daed81776c6244cc9cd"
    sha256                               catalina:       "5682501515336f0c090ecf8e7e41751d62d9409bf5e2b312904d4887422da590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "896932f90b58777ce3b22f2926c485cea6e64810f8d3b9f6a932de9a1795f130"
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
