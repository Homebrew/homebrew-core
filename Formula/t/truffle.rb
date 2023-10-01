require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.11.5.tgz"
  sha256 "bbc24698fc9964cd80acc8952500f708ef18984096eba9e75f40db3486392347"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "e6500d8c656acc698debd2bf71f07d066f3d8d519af39e6c7f4e7162c18ac550"
    sha256                               arm64_monterey: "ffc2638a4a690d9eb22045d16d61fc365c42075608dcb297c48c6ab7461d4700"
    sha256                               arm64_big_sur:  "52f39e675bdc15b89d03d6e12308f6438dcd96e40a349cd398c45da848a2e823"
    sha256                               ventura:        "b6b357828877823d3d474cd9c4bd6008328b1c111f4089eddbba2cb1c8798a65"
    sha256                               monterey:       "4291e2238faa646201e16850404c1970a1de34d1ea794cb0011a4e452e02dd93"
    sha256                               big_sur:        "a7dbb72f08ba81bb4580699ea23b55d9ebf031a9bed7c1f032f077e9736d545f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab14a38e62ada678dfff3ade0d31ad5d66f922c2a5851444259622e2248ca5a"
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
    %W[
      #{truffle_dir}/node_modules/fsevents/fsevents.node
      #{truffle_dir}/node_modules/ganache/node_modules/fsevents/fsevents.node
    ].each do |f|
      deuniversalize_machos f
    end

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
