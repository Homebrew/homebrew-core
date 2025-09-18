class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.116.0.tgz"
  sha256 "3092fddf84ac435e2d0bf28f7f31f7a523cd2126a3d4da75d2bb35ae4a2ecf27"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eafb5056d61211fdcfc299e6e82cabe27b4bb1c37a6028d1524bd3623938676e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd0326d87755d42e966e9c4ec817ec582670680847377d8da19ac80d552fc478"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "125a960e175c5e08ac908c80467c1c6fe7af45f1fe24f77ec33e82edc1af5313"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce73e1ee23eb7f124525df71073c81702b38df0a440479524a67e6d923ce92e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af0dcaf398c5544936811d90cf52916671aa3c74c1cbbf87fd30015cdb427d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3520dd550be6004b9883bbcd0f21d6bbaa04a902f15318e08b7bb8583e53f2e4"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
