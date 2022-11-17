require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.6.tgz"
  sha256 "a63b8d61c0a8e0a2e3c1748129632fa650a15ccf77a6e71834ba0e41b0f952ce"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "7f72f1de770c4730b4ebd2d15b4e683594feb245a94f22857e1d58c33b85ceb0"
    sha256                               arm64_monterey: "6985a56158e4bef68a22f4c5a00c9d37bb3a08f430d7008a6e1e9b1a6dbdbdd9"
    sha256                               arm64_big_sur:  "3f5a2b9a88339f11cbbe6796f676681d3a189eabc6a7ffb64184c85712482a7f"
    sha256                               monterey:       "abcf7e1acc62655438ae2efcc8a731e14088857535f0e7e596517f64c2eb8778"
    sha256                               big_sur:        "3b0907f8d6af9e5ffc3662f7ec11431d2c7640ad4b3bffc47d48055b2e8c3545"
    sha256                               catalina:       "445ec915f1dadf3f675680ecc88128354dfb3f7cbb3047d3ed4d6088a939fd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065f6b5b64cc2ce1ca28bdac48d5269dc874864ef9c1b81e276b5b551903dd3f"
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
