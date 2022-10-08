require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.0.tgz"
  sha256 "e57bfd93f9cccc010245f58643b961339707618bf1f5fa7709ec503972d9165d"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "a6f672458dc19465e80153a33b604764448edbb92fb5af87397906de62e5d599"
    sha256                               arm64_big_sur:  "1f260a0d97da2a6abab8ff4e6ab8d6e5158875dfb8c9f5d4fcb5e9932b375bb3"
    sha256                               monterey:       "421d2da3d4833ee1ce7f41eb46b3d8c6605557664bf30679657d6094f1d726c4"
    sha256                               big_sur:        "1c8beb9ea864cb599c8abd3e72d7fb91fa3061324d7f204325a15eadf4adfaa8"
    sha256                               catalina:       "5a2fb1ab20ba5dc037a0498ae879757449d7351dc8c464cb0373d64f50f0f743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067c3518de962b525179ead14658b6d24f3a252aa7a46fbe900e6b17b4d57d95"
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
