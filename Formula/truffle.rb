require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.32.tgz"
  sha256 "f44b5118fbc7cc10ad230a33c7505f61b566f48bfef9a5b75b64bb6b09daf4a8"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "b157456637dbb28c627ef71cf1cc35a5b499ed5963bbe653927b0445ba7936cd"
    sha256                               arm64_big_sur:  "a08f108b6a7c9cc5e57442d990d269ab193ffb35b85c935dc8c767f627492b96"
    sha256                               monterey:       "e0d727d3ab819ba480de7cf8b5b91cec55e462281bbf56b258911596264bdaae"
    sha256                               big_sur:        "04374330d7c36877b19867d229ae710f7d1fa7aa791269c7734653088fe308eb"
    sha256                               catalina:       "6a5555a1ace82bc938d4b2b0078f9d7f85c0a15f1ae4b1989fcfe2def567baf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75e6c92a74dabbd67df13abd115427fb774b67b4bdd05d972dd4f21d6da7f92"
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
