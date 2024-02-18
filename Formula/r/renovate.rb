require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.194.0.tgz"
  sha256 "fb1f2df23869ae3a85e22cf211bd65d4586b8f5fdf6a200743b3d1b947530b95"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ffec423d5ec5fd060e2173c75e0f5aea086708595320a7727e012895816c8f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ac1e6405a96b783b8e1631172d846293fe5aea46cdbde8f8ab60289b8251941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74d662002232102d969e30a160080eab875ca083dfd53a222c9a42024e9110bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "71306758a25e9c436cfeeb35d181a997ad825aa4ad5ea03ae7695d37d6a93ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "c04aa6e9ca51823788fe787d9bd7f640f81567a217eea40bf4ce8e761a4ac9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "ff9926f34442474d6abf720cb3bd72ca054f780c351df141418ba4ad3baa6f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8d7b5cf3d602b1d9193aac58a81cbb50219876df7a48e803f4028d46db995b"
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
