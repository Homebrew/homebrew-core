class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.23.0.tgz"
  sha256 "e7154cd23499cbcf74fee854333d9e68c5fefadeff4a4e3cb289dfedf4d57d89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91e617c808ec0e1a5ff4cdeb47d1186ab401a09b07bf5df4b1f9e0bb04e1aeb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91e617c808ec0e1a5ff4cdeb47d1186ab401a09b07bf5df4b1f9e0bb04e1aeb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91e617c808ec0e1a5ff4cdeb47d1186ab401a09b07bf5df4b1f9e0bb04e1aeb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ec3a895e36c49516e8ec7178344d865c5f0252438c6d9da0bc13143f97a349a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1452ef813283ef88cb6ad9f86d23132b3a3e75452f2fc8b23119e55946d79b16"
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
