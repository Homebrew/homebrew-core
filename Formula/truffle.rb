require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.8.1.tgz"
  sha256 "2aa6d516fd4760e9d3f43cd5f9548f8b1a8d6b36e30dacd371468d89775ebe25"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "69d8dff2df217ccd9971238a22178e777edf4dbd36460cadd4ff15d0712c8245"
    sha256                               arm64_monterey: "26f209159579f72c9b846100ae8b4f94a26d3eb87be0118c43206002aa6b107b"
    sha256                               arm64_big_sur:  "44b7a4ee6c563724217f0fcb280281130addc55998b81648f24fce8c04178075"
    sha256                               ventura:        "76c2ff3fd298984ac724405a24aa0e6333267704be86c740443e60b9ef8b52c6"
    sha256                               monterey:       "6debc4f8324e8f2cbb191eb1bdb1473b00a5ed4547db4dac035453eefc3e2046"
    sha256                               big_sur:        "0867a0cb13fce6b8186ebe8cf4949278fa42cdac32587e1eef30f98d777ec88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3577cb2a47f255fe911ba067144a564fee51bb9d682501f17ae0b2c4b379493"
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
