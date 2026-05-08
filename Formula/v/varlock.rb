class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.1.0.tgz"
  sha256 "fd830072df4b4944ac23dd4eb9fb2bb6a588d4c63ffafda0e4292767e8175042"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb610f7f5c18adc83cb6c3afce106d007ee31037974585cd4482c9f3ff9168be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffb8936a7f7cc20ce77522693297eca10d971238b9b64addb7b08bab1cca036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ffb8936a7f7cc20ce77522693297eca10d971238b9b64addb7b08bab1cca036"
    sha256 cellar: :any_skip_relocation, sonoma:        "289eff558e2a3633d7dac18f4c1c1439113311d4898c5a08ce2c39a4bb6ef7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85bf70151d5be833e5ae53b1b9189f3914cc5862a207c3d71f154ef013c46f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cad61befa721e76ca081f64e63a651314f623a4bbf69868cd30a1d570799a35"
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
