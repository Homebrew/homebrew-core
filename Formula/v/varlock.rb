class Varlock < Formula
  desc "Add declarative schema to .env files using @env-spec decorator comments"
  homepage "https://varlock.dev"
  url "https://registry.npmjs.org/varlock/-/varlock-1.9.0.tgz"
  sha256 "6e69f17d13fcd3156409804af1fd8cf334b9c0ac01d87051cb185894e5bf85c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9b1e4dfb00337d84e1c457b1905dcd60432f77d30d1385a4ddb8b071ba510cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4cb727ab13cbba1a0f5033bbe310acfc2f19c0993fe6d2132e1e96739c2a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4cb727ab13cbba1a0f5033bbe310acfc2f19c0993fe6d2132e1e96739c2a2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a8ee1481b3ce057b248a45a76d66bf13a8ec56c4f8152d965a5532c220a66c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fed3cc25307d853cf1cec361d79be7296d7c7ad29ad09c4951725e3c1a70c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b37334a82b52355c0abccace5a042345ea981ef5a1d932172cb54a078c095e"
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
