class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.20.0.tgz"
  sha256 "69060cd72113f4c0e3b5c1333b47ca6655476b4bd77285a5a57e404a3b9ec053"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3505fff113fb12cfd74971a32af36f3267e629192b4ed47aa8ba7caff67a8fe9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3505fff113fb12cfd74971a32af36f3267e629192b4ed47aa8ba7caff67a8fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3505fff113fb12cfd74971a32af36f3267e629192b4ed47aa8ba7caff67a8fe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98542dcaf4d67124c2ebcff56940034190341d790d8cf191dbda00f56036d827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2e5aa86c25b4da7932bf15c76b4425042fe013fd7d3465c4fd71d6d3809de9fa"
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
