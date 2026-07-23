class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.13.0.tgz"
  sha256 "776bde26f63b1ccfe8376ce2e16dfd47feec967f51fc580ae0fe6d4b7cb2f486"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22e2e3f5d9a23d36faa1e15820326ac8debc37d9499fa0d4373a063b12baa94e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e2e3f5d9a23d36faa1e15820326ac8debc37d9499fa0d4373a063b12baa94e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e2e3f5d9a23d36faa1e15820326ac8debc37d9499fa0d4373a063b12baa94e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6583739c121b97a61b9c8422f1daa9d0d2ceaad623f0f70384b92e5a0c45e17b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91065a5766978fdc496fa15bac94dfa6628f763990bca3d1a08deb1af94d7c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abde8e6af893d337898ec86075ec119b7a869a23bbe65a1f73292f33cdf2e128"
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
