require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.6.1.tgz"
  sha256 "557d7cc99af79ae8135ab105aa372716aeff6c5ea33b09a897fcb64f1a7df6ac"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "db5d041ce5eca4875960cdb4ae9d748020e948837cca90d4aa2bd3094c963feb"
    sha256                               arm64_big_sur:  "02eef158564c0a79f229ccf26cd3ff04ca6439a572133452c8260ae4f4aacb87"
    sha256                               monterey:       "fd6775f155303a0f0eedaf03c69874b738f8e81fe16fae5368c0d6726328d694"
    sha256                               big_sur:        "2ecf52c0a23f111e0c67f0ea63d51294fb0291e5237a9fb2a2347a9dc129d948"
    sha256                               catalina:       "0df0581411af851e62dab60187fa23f648cd5884e78f5d456ba9ec24cd4b0f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da9f51a64bfd8e318bbc7caf189fe2b98b34c37ee696df5da220bbb05c9f51f5"
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
