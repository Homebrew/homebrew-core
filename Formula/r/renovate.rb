class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.161.0.tgz"
  sha256 "d77c77f4d51b301497b7a1abd2dfc48dc5e7373f0233476d81697d941941dabf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4126fa5004356e622216f10cd8bb256a462a170d6918c998096a2266bb6a5ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8fd82d5d61b3a7ccaf2d7c1e4a4ae6b3c08b940181b333b2b61396d85923356"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9498070da41f0971b682138e210efb97d9a5e9974dd68b3bff1040d920dc9dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "188c4863d6d41c4d340b4701bc5d1f8829c7fc76737b9c9f335afde8324e187c"
    sha256 cellar: :any_skip_relocation, ventura:       "fd7491ed85bb72ebc32f81c00705757bf66e80cc9d22d5fd31d9eb61a8ce636b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3532d10462d16268dceb9841b54b6de02fb081c66175ac72118e5536e197882"
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
