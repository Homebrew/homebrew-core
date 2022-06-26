require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.5.18.tgz"
  sha256 "c3c125ac9777725d0bd08778b76e1ea123918a774b12866441f81f84683706df"
  license "MIT"

  bottle do
    sha256                               monterey:     "4c798bd79deb6dda407486614f4e5713167919dfaeb2e86f1d8d14dfdfdc1cea"
    sha256                               big_sur:      "2af5aab28142385ababecadd67874be9f92b9ea7e59ffc816f94caccfd48865c"
    sha256                               catalina:     "cc2bc564fba6daca6c596344ad845cd13be05afa54e4aba10a1603dfd99e1307"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5c4e729241a3517718e2e6393aca94998dd5db0e215606f2d0dc0e2ff09b4ccd"
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
    if OS.mac?
      truffle_dir.glob("node_modules/ganache/dist/node/*.node")
                 .each { |f| f.unlink if f.dylib? && f.archs.exclude?(Hardware::CPU.arch) }
    end
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
