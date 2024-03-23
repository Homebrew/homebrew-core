require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.266.0.tgz"
  sha256 "4d0f2f967be54fa776a2cc3277d69f4a60fb0aa496b9e4db1d3045797189ca1a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abafe1d0988e762d80648c4c9b2fe782d68662e885850765f5f96b10f8053c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6effd02030f923d0591ae52a48aec9248eef36239420d841b8f4af937f5b98af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6cdf25e577ba785f0674eb0fda7bd22e0febcef1cef1bc101ba635c60af2b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "38241b3706ad9d3e3fad20db88a5faa89d4808fc228339434a02bbd169f6a5f7"
    sha256 cellar: :any_skip_relocation, ventura:        "5c24be253b3a0ff48f5f3c9f93eee6872c3698e2d314e753b5d7d0569c8bc845"
    sha256 cellar: :any_skip_relocation, monterey:       "6d9926ec03a9bd542a357d8dcdfba57e7aa1fbda8972e29485ebf0639b13b650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e44783104a4ed640512e0b47a1973cdd595cc14bb0f8c7b10f9f275b3b9a169"
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
