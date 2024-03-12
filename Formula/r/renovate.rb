require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.236.0.tgz"
  sha256 "4baba892da34c9e4f98cc6cef9cfec2748480c3887558aa8f274339ee05d36dd"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f601fa4f263a6a9b5e31ddd59bd41e2acedeb91713452f547ce7c9ed75794c5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f9cef45236da1cbc96990a08d3021f15b6fe6e1597ec241305883af5fdc318e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f561ba312e6c75656bfbe9966c77da8efb48cbaa155a7d52e2f1f61cee76ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "3850df066d8f01472884b43d0e8197eb230a8c8bfa2a66b6a3b151eef34e14f6"
    sha256 cellar: :any_skip_relocation, ventura:        "0ed18304140acdfca3b4703a2f4c99f31d5933a0e86503056313924bbe288f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "61cc6ad755fabeaa62d8883914b53d9682e0bfda874b8feae02785157572962b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7fa3eb43ac2fc3cd5a263852a4c4b09cc636682ad5d87be66c6877473b9e18"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
