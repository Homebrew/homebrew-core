require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.6.tgz"
  sha256 "a5670ffd17bfb07474f1e73c294f33ba2c923051f072d272757f16805dcb2410"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "ba1bab754fac8f4f2452af53f0840ddd466018493163e1133e6dcea57077d4c7"
    sha256                               arm64_monterey: "adff67298231cbc780d06d5b4ff8f777b1d491acfc7c68d101dd8477d4f74c8d"
    sha256                               arm64_big_sur:  "80ad1b5f3f613b588760b1166969f71b319787cfd8f64dbe8a3365291d2ddd20"
    sha256                               ventura:        "2fd8d061e08b66d27a8d18b5cea808649df2b1963d1d7bd5dcbb7e8ecfb6b100"
    sha256                               monterey:       "0c18196e67622901d42b0f0a7aa61c81f55561d3decefbc5f3c88ce9a2d8b10f"
    sha256                               big_sur:        "c00e59d3914b5be4ece91da59922a25a43288be88b4b721d1350dd7f0294a524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d6ffcde51910504a98de5ebc8e6ba3560d7ddc799ce51c2ab1f723ac8895c2"
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
