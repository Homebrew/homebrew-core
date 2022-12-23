require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.1.tgz"
  sha256 "6337cf619468a7008d30621fbc9e2c7b3b54dde2eed46342a3e874ec3a8f53f3"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "1132b7eebeca6cb0703566714b2455d50f36dd725c990fd621c924f489e48826"
    sha256                               arm64_monterey: "e16b54dfb6296c672511eb1ec68649eda598b43216061d87317f7f1441051526"
    sha256                               arm64_big_sur:  "27b71358326bd102aef2db7e328d738f854749847a7a9a33fe0efaf40ff5e73b"
    sha256                               ventura:        "0bc82ad62ce361313616f7b928cbcb18348d4224e261889c6d936d0041cb4326"
    sha256                               monterey:       "c567668f7edffcc911ab8c385ab0cde1a1e8ed7ca86edd5c6cfb37479e72f77e"
    sha256                               big_sur:        "4e0ce10c48fc92d9e53da6b9a56edf1016633f28f9c1256c5945a08e059ba6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059e104b0657ec334b8efb2e6fa6704ea3423e821081bfc5ab6173f110159d0a"
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
