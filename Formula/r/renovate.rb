require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.228.0.tgz"
  sha256 "b549f8495d62ad9b3bdf1cdf72e1c4a1b6f0ec4eb76e269db500e3310fba62d5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b638363d1e6c3fa90c5c1db97d4d8b93d5fd2b6de1ad65488f70ab047991345"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b3612fb661682018a7bee9d88b4862bd6b4b47ceef6bd64c5d22ea5a900d296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf77bcc001a8395fda84ec24672668e29fe698078f6608bb59650b5bfce2ee0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6e2b3ca8346c770eedc89e9de2bcc10b500eebbe15f365bb620c846ad1166a9"
    sha256 cellar: :any_skip_relocation, ventura:        "bfd297d71a0171453aaf821fc753995133a9e8e9b6942ce360f01ca17f399aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "c38ad27541c32c8a26fec8b449d4fe9d4b71764a1598dfb756a2d1b131f1aeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50fb62fa61eebd735f69ce9dbb95ed7144731f8037f193c25e907ec7fa728cf"
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
