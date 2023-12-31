require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.115.0.tgz"
  sha256 "9319b1ec876f221c970efea21c824f1b0b5823912d8aac2377123e4f185a9eae"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92c8f7c3db859968e897868c4100b625f39215f70d7ee1bd936575304456d55b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd93ea34b9dbe7d2426c312603e763553117d676e17d3d7711ec516d5c9759e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b714001d2336c5bcf36929c5348255304672d30414722332d47b6e017764e63"
    sha256 cellar: :any_skip_relocation, sonoma:         "51b1b7cee9cf26b9b380c32550e8de14d608cb909f3e746ff82522724c653c26"
    sha256 cellar: :any_skip_relocation, ventura:        "5eaad1551774e78dab5e990a423ec9a8d3ce2caa7907c1b386ee61a778c19282"
    sha256 cellar: :any_skip_relocation, monterey:       "267170b5b165d48b77c8d08fb03a4f42443193c464be1d264c688eb75bd18f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "389d59602aa0706274fbe639631dec33b110dc45f8ddbf5f544f772c7c9a3827"
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
