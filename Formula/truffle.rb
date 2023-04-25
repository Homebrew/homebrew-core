require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.8.3.tgz"
  sha256 "3a0f26d4156c719cff9451742d9d3c18b11972fe99e927dda459056b5204d7e4"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "37b696dfb77cdf6736b005ea0fe3e7027cac5a2290a5c45d5a33faa40795cfa6"
    sha256                               arm64_monterey: "30305036c1f9b688d5a11ed74761ae669d5048c11f32dd2f55bed062b5ede993"
    sha256                               arm64_big_sur:  "bec63c049e0380fc1f73978ad42ae1dcb9159d32bcfd0d4df569c6853623072b"
    sha256                               ventura:        "a211f314ebce4b54033c1c3ab5405b105f949763153ce5b847fcfcee82de0928"
    sha256                               monterey:       "ddc5cfc7d0daae8195ce3559717b947ef1dba3b0fc1c4cfae00ea791c67fb94d"
    sha256                               big_sur:        "e2ea268689483bc4f9cfcbef106bbbc730ab62e9b5470f4eb36f7a416a398e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bb791e97a911a9b92260aa6e3bd953da5bf4f949cc900009872c0dd17983103"
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
