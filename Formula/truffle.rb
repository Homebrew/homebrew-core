require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.8.tgz"
  sha256 "b640567687cd46902c9d3e47bf67d85303cf4f4bcb89003ba04b7e5580269da2"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "498689feddeef8e282d4739177409c033dc4e8aff9eb306e33856dff88a95f2a"
    sha256                               arm64_monterey: "cff31151c9942f689c4cb8b7516edf1d9c552a0bd2d1d39e3e2d986ece311e0e"
    sha256                               arm64_big_sur:  "98480fce2b1b7fd5a415019189a84781d4c239e319e0b8d1bb5e7bccbe318768"
    sha256                               ventura:        "37ec68efb0f6dde5fb492d3fbb14704a1b649612ceb3cb4e316a5ae121d7fc30"
    sha256                               monterey:       "940c9504d8282b9ad0b14e407dcaff485467e7347f5959c8c23d4add8692a1bd"
    sha256                               big_sur:        "7070b306841756c105006ef4407a43ed1ee5303232a26a6de962688eb53681f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30484fee4d3d6a6bcb0ca5b5fa2d475f133dc6631c12c31de440dbc88b52ef1e"
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
