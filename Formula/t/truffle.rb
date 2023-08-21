require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.2.tgz"
  sha256 "e23937734dd7e56d3235919d9aae1ef1b1d96a804bc176947a5f6ba49c7739dc"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "d51491ccd1b9360ad550c9637395e0e6dcfeb4f5429a8b779cbe4fe6122ee652"
    sha256                               arm64_monterey: "4e23618e9193ff7d754d0c99b1731dc6769f6f1b857aa70e9870290176c5a26c"
    sha256                               arm64_big_sur:  "087dfeb7f82524b41a3fc83c17626aa9272ab20be6e65ad59f7fa60d9040a841"
    sha256                               ventura:        "94be46806d7e1d90b87f829eb8a7348acd869bd9c50b1c2b5652093cb2532b7f"
    sha256                               monterey:       "df2dcf1f252d6efede61f57728c33580c0d50ee96deed77729b5199b9c40ed1b"
    sha256                               big_sur:        "d92a4902e7c3df4748c39fc461def70144df4ce063eb448ee9bc6ed4812b8cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae06a023ffd2635bb069a055856750fa9c50fd9e6da14db8487ea7e562c8bd7"
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
      node_modules/ganache/node_modules/@trufflesuite/uws-js-unofficial
    ].each do |pattern|
      truffle_dir.glob("#{pattern}/{prebuilds,binaries}/*").each do |dir|
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
