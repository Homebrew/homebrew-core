require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.3.tgz"
  sha256 "7faa8c5a8b6861bcfe5cb0821f328f5f228bf63c923817a755b6fc05c498a716"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "051532b2acae13f7d40c66eb469c678200174a2e6911854dc3c794d833e1c444"
    sha256                               arm64_monterey: "7718a6f228fc1ce627b8836a7b891cccda0b2e83f1954f95dea5f1dc198d1125"
    sha256                               arm64_big_sur:  "eec9379439f29e71f7b44a767b093b7d7f41e5be59c91713258bb3dc606a56eb"
    sha256                               ventura:        "326af247029a69e767777416a9921d7e46efa4581d66626857d65345f3eb4941"
    sha256                               monterey:       "1050c8cd3eed0bedfe7002963a4754ffe405af86542e41718c21829e81045b36"
    sha256                               big_sur:        "cd4b0b78027c09463baff71f93ff364d0b1973dc8ae5dcbb23b4c154ad865b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf599b36d74846bd34c02665dddb1287eeb84ac817eae20c04d0c6cc8d68133"
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
