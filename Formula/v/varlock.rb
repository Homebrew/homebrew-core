class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.2.0.tgz"
  sha256 "5c0479cd8990ff4d13ec315999b0fc1333b2475d8eb047bb99f29e0e765957ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "591a031c63a128e5a8fcb933e3a590baddbce790d826f91871bcd9dabe36c41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ebdee9273329f951387fc3e27bd1ae1e2e19894655ec6d1cf4af6a45871c6e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ebdee9273329f951387fc3e27bd1ae1e2e19894655ec6d1cf4af6a45871c6e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fa44cdfd4e09f12fe351d2db066ac0eb2cff73a7c30886e512cc5fd1e5f2310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "518ad40144fdaf01564b9f160df5cf2746bf528641b70f9b91f38a7fdfccf95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a94ff9d8affa5d57d9a19e2c6d16686c06c5f121495664c458651dd9547cd9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    mac_bin = "VarlockEnclave.app/Contents/MacOS/varlock-local-encrypt"
    libexec.glob("lib/node_modules/varlock/native-bins/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if OS.linux? && basename != "linux-#{arch}"
      deuniversalize_machos dir/mac_bin if OS.mac? && basename == "darwin"
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
