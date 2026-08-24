class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.17.0.tgz"
  sha256 "dcdc135526d750c0381d01c0d6cfc99b6b0b05e9cce9b9da58605f5e9f0ac416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "668846def45fb1687162e50b16dd2c9e256050eff8bf9c6d1ba2cdc3874c9f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668846def45fb1687162e50b16dd2c9e256050eff8bf9c6d1ba2cdc3874c9f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "668846def45fb1687162e50b16dd2c9e256050eff8bf9c6d1ba2cdc3874c9f6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "433f7fd4ccaba9afa992f778b7dd5ebaf48e4f0c5c35f0e6b70434a463d76d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d25bf3d1f6728a968d6df7c84bbcd08566d40bd3c06742800f03650271adab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1f2d50115c457b067044eabbc0161de4d4830821bcdfdd7deff37a73cb5855"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    mac_bin = "VarlockEnclave.app/Contents/MacOS/varlock-local-encrypt"
    libexec.glob("lib/node_modules/varlock/node_modules/@varlock/native-helper-*").each do |dir|
      platform = dir.basename.to_s.delete_prefix("native-helper-")
      rm_r(dir) if OS.linux? && platform != "linux-#{arch}"
      deuniversalize_machos dir/mac_bin if OS.mac? && platform == "darwin"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/varlock --version")

    (testpath/".env.schema").write <<~TEXT
      # This is the header, and may contain root decorators
      # @envFlag=APP_ENV
      # @defaultSensitive=false @defaultRequired=false
      # @generateTypes(lang=ts, path=env.d.ts)
      # ---

      # This is a config item comment block and may contain decorators which affect only the item
      # @required @type=enum(dev, test, staging, prod)
      APP_ENV=dev
    TEXT

    assert_match "dev", shell_output("#{bin}/varlock load 2>&1")
  end
end
