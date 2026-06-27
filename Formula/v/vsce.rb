class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/@vscode/vsce/-/vsce-3.9.2.tgz"
  sha256 "4bea17e6d22d7470d024e07f8ff5611da04d9448be250db77c5bddb473a6ef36"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/@vscode/vsce/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc33e023eccb572d9611b5c41b1bf54cd80d4ffd80ffc43efb787fb22a1e91ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc33e023eccb572d9611b5c41b1bf54cd80d4ffd80ffc43efb787fb22a1e91ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc33e023eccb572d9611b5c41b1bf54cd80d4ffd80ffc43efb787fb22a1e91ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f575023bb4fd3c5bc0fff3399a025753395a7773227ea2a0641c816c173e81"
    sha256 cellar: :any,                 arm64_linux:   "277b790509802b9c5db6784a4ab6cf071698abce1fc88d3c3ffd5723cb632975"
    sha256 cellar: :any,                 x86_64_linux:  "71b2b6bd8f2b78ef985778bd2a2feb27197ae538cdd513329a8e72655bc76e88"
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
