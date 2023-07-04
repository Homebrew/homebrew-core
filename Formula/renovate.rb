require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.159.0.tgz"
  sha256 "99a9a6c3612992ab5634b0de38c8900f20a8fdc44898d46f66c15ad00e0bf2a8"
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
    sha256                               arm64_ventura:  "22b2c5de88b82ef87c0d82cb1646bd97e28b29d2c49f2d62570c1931aba9106b"
    sha256                               arm64_monterey: "aa59e01a4bb4a3e6a241de7b2bdc3a7bfeb492ac33c52c40ca1d4692b3afd769"
    sha256                               arm64_big_sur:  "a6cc7bb2ffdfd5f0f2ce6613d646f05f77531b9dcf28ca7a749d81d3f3336aec"
    sha256 cellar: :any_skip_relocation, ventura:        "fd0ba3d251aec9384b0bc57d42db082f32bc7be824a5f81a2b176b526d804f4f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce7491203b3aca5cae86ca54ba4a5efb02885d1d0b23725f86c9b278b9a679c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c6e167bc0d93daf51354955cb9958bf46f7698a3f7234ef532013f671c5f299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf23c72f242809816a4d56fb1cc193ef4ec95b434f91cd599e13c3e7a25f973f"
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
