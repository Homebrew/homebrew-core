class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.211.0.tgz"
  sha256 "0a3057ec66ee557ee1b42096bb6e2400b5013f54c490165b69a9a8f3f953373a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "092d455be0862cf4b27eba20e4c687b85b758e95569efc4631e250a773f9b407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0820f41e389a6ad6c792deb09f950f552edd1fd30a6bd76ba7cf1759aac70866"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b16101a18b4faa1093903d681111a68e4ae1ff6a8f6f2a4db68a71ef0c86fa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8790b6adcb5904c36de3e8565a5c05b2180bfa4f79425d0041274140d3aea5b2"
    sha256 cellar: :any_skip_relocation, ventura:       "f68de79b8530b81dff286bbd6a2738a8a4212014dcd6558964b04107657a75da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83258b38f4064bd6f1afb724977b53fc4eefd1ae54e671cc012143558ec46652"
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
