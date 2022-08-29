require "language/node"

class Vsce < Formula
  desc "Tool for packaging, publishing and managing VS Code extensions"
  homepage "https://code.visualstudio.com/api/working-with-extensions/publishing-extension#vsce"
  url "https://registry.npmjs.org/vsce/-/vsce-2.11.0.tgz"
  sha256 "165f7f3215449f62f875e8068301a3b4ccf33cf0edf5f93fddeaaa8981d88645"
  license "MIT"
  head "https://github.com/microsoft/vscode-vsce.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/vsce/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256                               arm64_monterey: "3b152ec2f85820637eb1b7b9d4b5e8db5a1f7248d40f327af2b688be8b881fdf"
    sha256                               arm64_big_sur:  "056229105114777fbb800aeb7176b45027f4660c74afc1672b54b5514b5eb4e7"
    sha256                               monterey:       "69b78ae9bbfaf7307c2e6ece6618457c3f0b23556cfdec31faa976df56a15bc8"
    sha256                               big_sur:        "d8620942ec5ac10db687b1dc326bd50c4fd1dd06a158bdabd76769787de222df"
    sha256                               catalina:       "105af836d15c41d2a13d51c0497a158645774d098f72b0216c1addaf9b0e0a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53423af4bb4750763d79838860f4e0b90f9922e990aad070b07aa26de53ffc05"
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
