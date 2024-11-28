class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.34.0.tgz"
  sha256 "09aafdfabeff7cd54087c905feee5ade779e99e42f1324972b64eddbb001773d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ae4ff3fd33f61dd4a119a8ed3f4c3f819af72e1830c955da13bb2b6a6da71bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00742f590e0fa954edbb6e475c482b44ead0681bb09206502241edd135fb6034"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54ac461cb7b71a7682bc0eb20f180666d72d4f17020a33c3ddd2b491e0975560"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae1adec4a505b568b3409eb36c57e229a2aae8d8a9574530d3a7d86dfb1af444"
    sha256 cellar: :any_skip_relocation, ventura:       "73d8c251780e92b82be41bcfca9b605d4eebafc9b6c9f91b1da9a53f5e74e0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd693c1643be55d5eecb63d8722968d276dbea5a5c7854d9c357ff5c11fd2b8a"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
