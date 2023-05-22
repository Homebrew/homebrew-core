require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.98.0.tgz"
  sha256 "f8ef1cea9ba3f113861dc34cae32b9d59b88457e541935d1f25b0b2fe8c48617"
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
    sha256                               arm64_ventura:  "1852efa1fec3a6755fed59634e9cb9f62e77be2d47a78995bb7bcc713a07bcbc"
    sha256                               arm64_monterey: "f46f1bd876eeafb1b988862ff0c7326089e82eca08961ebd6dcc44effd85550b"
    sha256                               arm64_big_sur:  "dc2c7f6ee8b404cc47982fdfc35d9b7ed9eaf7b32e32c2df4c559acf37925767"
    sha256                               ventura:        "6b0fad3e37ee9894aebcabfa5f7c263a7c36fa30678d1159b8f535de2c468bb2"
    sha256                               monterey:       "78ed1ac387fafd83757ae3f9833a8eebcb26eee856a34344350938c4f0d540bf"
    sha256                               big_sur:        "58c807655f7b690ac4caa9d5b59d239b08fc8f63410c866a48c9665416c2aeb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a5f00604041434375aba9c31b31439a6e5012475b8aea9e7c1a9edfc1011d7"
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
