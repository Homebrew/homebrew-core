require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.7.4.tgz"
  sha256 "ea215e422a9753ffc7e9cd8c981b852a800dab1034fe729019c49ab1e6fe3131"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "17f295be7a5d58db564da7e2ddf87ddc313f64cc8493311ad92c6dd918da5fe5"
    sha256                               arm64_monterey: "d92a77d0963aca3c346da47ef86ec3b3305390d7807dae29240df8a726791458"
    sha256                               arm64_big_sur:  "ebf701e249324a113f0278be34648698c85aaaf7361887d4fb16fe9f395edc33"
    sha256                               ventura:        "e153296cffd27acc88be7d9cb9d48c91c374e087b7d9442084f0ddcb9ac3be5f"
    sha256                               monterey:       "e011357b2286eb1b467b61f6519611c4840b1a116f3561d480ab1d7ae4172651"
    sha256                               big_sur:        "fa59c46becb41c3c99b1cb7255a30b808d0aa3ffb4e8f988a8cf136fca68641e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c365c79c396e5ca8a37256fbc541737058dba2420017d7440a034004b088d8"
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
