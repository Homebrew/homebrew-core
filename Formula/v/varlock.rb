class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.5.1.tgz"
  sha256 "9cf78b3b37831735d07b5d59688f98cd521ee7d224e17c19a4e1289eb020a0fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ed699dbe0cac91ed2d584eea8f9f2296137ee44bfabd24d7f857e34e0f81d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "941b170ac85bba1b286d64106b60e8106dbc41a94f450572bc1f531fb32e8d73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "941b170ac85bba1b286d64106b60e8106dbc41a94f450572bc1f531fb32e8d73"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e08331ba2ade5b44937d04f017d80e3e36eea269a8e8d998ce81684494c4d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc247620e1a86ef1fa1ae06b45044f09343dbccb89ae83252fa5a0ec66c55a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309fd86ccaa5eb1ddd2def57b2dad44a1cd9c12b745575abd1ab788d3f512cd5"
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
