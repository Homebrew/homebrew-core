require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.9.1.tgz"
  sha256 "c5ba4a68b6b4baedfc415fb26eda07c2114cd6dc3a5e65c1885721af707309fd"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "c034a8a45abaa676c39bed8fa88bc2468c3e4e8d01232f4e388c6d5513bee483"
    sha256                               arm64_big_sur:  "5043d37a198d65ace5971ec4d2bba613ec904e75095dbf4027c5272e08c6c6dd"
    sha256                               monterey:       "eb99c67445ba2202179293d1cc49a1f9336873b9657c984af64379358250641c"
    sha256                               big_sur:        "449529edebed2d0b174a1b7b853db530ec5a95d158ab4d4f2822d85803f80764"
    sha256                               catalina:       "bf29e7920a4d7dca4deba6c5ab98c438e2e05d80b1c9a9eeab77e6dd3dbdd5da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c916c60020edc78237ea08caf65d6bb59e8eaf12474fcf79d134a437952d4db4"
  end

  depends_on "node"
  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output(bin/"vsce verify-pat 2>&1", 1)
    assert_match "The Personal Access Token is mandatory", error
  end
end
