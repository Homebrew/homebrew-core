class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.25.0.tgz"
  sha256 "cac51a856bb7134e518a8b766ce30d526035caa227b56ea3cc807ea8cc4305c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f453216f8b56e384441d5630b0b1509167b880821ea1ab1c69f56234b126586b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f453216f8b56e384441d5630b0b1509167b880821ea1ab1c69f56234b126586b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f453216f8b56e384441d5630b0b1509167b880821ea1ab1c69f56234b126586b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6641717e92269f641552f47803c2b6c63002b8e04c6ca45b1b81b300b431412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f06aa6f86e3f7a0b54373d6c3b80a7a024d5a374b54003b2b08e9adb4bfcc134"
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
