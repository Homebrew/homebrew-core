require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.141.0.tgz"
  sha256 "7139a748792a231f6d1e35c795572452d9ac9369d8e0c55ab3853a97e0df6840"
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
    sha256                               arm64_ventura:  "b14e68096bb238b5e83c6a838ed9843438dc3679528b1890c2474b4f92f45309"
    sha256                               arm64_monterey: "bb295346fe2244d59b6b87d04d56e2b64469fa85982a4856ff402a0eded9a946"
    sha256                               arm64_big_sur:  "a7a3837d2dfdca4183cf5ae0cda50a7f7984d5900d9d837b9e7a688cf74cd582"
    sha256 cellar: :any_skip_relocation, ventura:        "0060d2b0d7567a04e526f95dc7649306a94e3a930615b250a371adad192b8f86"
    sha256 cellar: :any_skip_relocation, monterey:       "c66af84fd9d21a73f0727bf53dd4572753abbdc81844fa866f85ae5112571ce2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce6d90180563228ce8be42123032aa0e9ae7226c7c0e44f7562b3c432f9415af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f830039119abedc6693b799a598d586ccfe992f01b483305375fc9af8ca628a2"
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
