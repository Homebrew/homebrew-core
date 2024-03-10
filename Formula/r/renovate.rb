require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.234.0.tgz"
  sha256 "25b928b52fea5a3b1ef3c8a15359c324a1836c289117a685c176d7aae1d0405c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc87be948101a5059d71feda0a1d9452a494e484d3e9648cfef57d12eb220061"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c1b4db47f896a684518fdfa26d882d2c48f7698818a5f5746a79618cbb5635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919222b35cb37e027df4785ba1b261517c319b2f2c0c18126dca4b65d16e035d"
    sha256 cellar: :any_skip_relocation, sonoma:         "95343bea2d36fc9e1edc072ebbc2a2c7588fe1e0b6c4a5c6dd162395bfe544c5"
    sha256 cellar: :any_skip_relocation, ventura:        "9672c60f36864057525ae0204221fcaea08a85f328da596129d1b431c4e9e318"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b3aae865716c56780228a99b65251deac40bb956214cc588173881c030f831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5229d8802a9e331e7eca0af0a4c099c9f9dc70c998c06590e1fa3e6dd5552f8"
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
