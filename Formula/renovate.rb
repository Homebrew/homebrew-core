require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.53.0.tgz"
  sha256 "e6fe6cbcd456b2701f34d93191c99d0e76d22a56e26fbe66daebc582e3fc4061"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "4f5494ca552ed7a622c684bedcdc5d3bc7ac5bf6c453bbdaaad666ae1b67f00a"
    sha256                               arm64_monterey: "c5aaf315de554977ed9fbba67e22b552b3acf294b9b97eaa5202a83637c3a1b5"
    sha256                               arm64_big_sur:  "9cd881372debca4adb666fa7ea72b3bc438e9ae1da00b9aaa958cbf0f17bd2eb"
    sha256 cellar: :any_skip_relocation, ventura:        "44d13d0434f95eeea3df54d6da1178cda751d2ddaf2ce122b10763cef221c4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "eeb785b22da8f54b84654a78ff1fdbf06fb2a0f14dff6b966cfa0883ae5704ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bca41728ebb6e4f1b296890a6212ab9056a8a5fb88490946458813220840414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8b225bc6300b634f43cdae67a7d0b3abd34127edf04efe03ef1bf1bdbea8ce"
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
