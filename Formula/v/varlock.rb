class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.10.0.tgz"
  sha256 "6ace9b6e96f7e51d8282dde89d81c3297f9555ea572e5be6f2b202ccd868ad2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b337c61dd94f8fa7258cbddcb90a8762c88b80fd998e3835d54d3a8c565ce911"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5c1d5a21d75ceb432ab6312dc36945ce0677de7fd36544e071dec827e76f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d5c1d5a21d75ceb432ab6312dc36945ce0677de7fd36544e071dec827e76f2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f151a85496d922fb7be1a6186f32d0299bb97211b1e20a16e0b37686a7f289"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "530393f0f2084b0270ac1d7449af92d8de874ea3ffea7c3b61fd7e1f956b53e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f422dd75de46f6e3b53659106df25fef6e561e385bcd8857b383348d4a6bc0d4"
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
