class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.58.0.tgz"
  sha256 "43b9febbecc5b56d50efa6b96cb2fb3e3c1f3955e25a96eeebbf8416eac82af0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852684c284d7ed30a767a4b3f8f5cf7b769ad1a506579e04a981e9b5b342da8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77763012707228bfe412d0656cdaf7f26e996619148fce96aab939620e1e3826"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fef33f830920893d6662ee0dbce7ed80d14816eab82f61aae7c91e5b384bdf44"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfae57cf2fd6f9702b7e87389cc5e87d0dbc2f2dc48195075b72f2a37bc6ed0a"
    sha256 cellar: :any_skip_relocation, ventura:       "aa64a3707a7b70c060049814c3e77401da2641da8a44848377af4aa38d77e118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccac165b1a848041c7aa31362008be44778acf241e4f7b8e9bff27b1cb4b729f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5fa0323100f46dedac8d1c6f42549070675273c10539e13c9f22ea65078c661"
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
