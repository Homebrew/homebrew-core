require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.5.tgz"
  sha256 "dd2bc2c8342c4b71bcabc63d25b78e86cea828af3443403f39cb71dd500349db"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "f38f734bdbb59beab5fa30d44f03ef95e0ec98a88c4259f9cca2f83413bd3dc8"
    sha256                               arm64_monterey: "2d5a9cc7c6a963e553c0bb88cb7ec9d482d4ed563ae7f183325b386307835af4"
    sha256                               arm64_big_sur:  "be071af7f39eac52397e8a436c0730b1efe51af8fd86e4d39164ab0dcd9273b1"
    sha256                               ventura:        "c58c05761492f4404c48e86b2e6d8b01a012d60d7c15b2c20af1c1446ae4814f"
    sha256                               monterey:       "c3e21b4ee71b83448b949285e238da797cc151b84e0075ade6e4dcded296d7fb"
    sha256                               big_sur:        "1bf8cf01bf9e19cb5a9938fc0d80154491a79e35b238ae68c2daadfb10764ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ad1701b24aaf9ad4d4d6a494d50b53e801280fe913c2f45e58f4e6d1b403c2e"
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
