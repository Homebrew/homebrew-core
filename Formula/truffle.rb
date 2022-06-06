require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.15.tgz"
  sha256 "2167a744b9b046875ac75e048c0936ff7a627c273f3ecfb25373e06fc85631ad"
  license "MIT"

  bottle do
    sha256                               monterey:     "a1ddc5c1cf0fc3126606462ca65be39d677ebef6674b7906f78baa617f2e555a"
    sha256                               big_sur:      "334d3bbc101bc9392931cea3a6b6e4780177c1b50eaccb193842688e6c35d6bd"
    sha256                               catalina:     "057d640f02a69b54a037274b2475955d3f466996a637894e6f188bc42ffe93cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d66d788bd3bc0a8f4508f75526637d55daabb73d470d9a27b9a0dcdb36f133e6"
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
    if OS.mac?
      truffle_dir.glob("node_modules/ganache/dist/node/*.node")
                 .each { |f| f.unlink if f.dylib? && f.archs.exclude?(Hardware::CPU.arch) }
    end
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
