class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.9.1.tgz"
  sha256 "986adf4550db8d16825c856c74851cb020f3b8bbf261b37a7cbab34429186b4f"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e20db9724cf74c64e382d950930f4bded9c285d1d9dfa26ce9dd5e6b7482574e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e20db9724cf74c64e382d950930f4bded9c285d1d9dfa26ce9dd5e6b7482574e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e20db9724cf74c64e382d950930f4bded9c285d1d9dfa26ce9dd5e6b7482574e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8393771667562a37c23a519fb01cf71f0663e2953e756d0ec41f77f9159a5ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97e0f23f09108df09ec2148a3903593d4af5e3b169768b9f666e72505eb224d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45e755f38be0fabfb62c232aa17973dd772edfbcc99f493d6607cda0209ed5c"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/vsce verify-pat 2>&1", 1)
    assert_match "Extension manifest not found:", error
  end
end
