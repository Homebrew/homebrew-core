require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.263.0.tgz"
  sha256 "60acd6a91f54a191d8f9814554585bf431d4cef1abea21731e3f3a9da9f4c26f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c45a3c7cb003dd53d56a4e1e887d50323f57ff0fa97833f896c36b71bbdec62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e069bd34e348ea3c0aebc0f7bad06ff78e4ba903ebe2898718d4f67e31e5cdb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ba60ba5f7a54ce283455d0f33bb46a36d213c5baa046d0ccc92e15e21c567c"
    sha256 cellar: :any_skip_relocation, sonoma:         "edbbcb1ad339ac7ebe2503fb840e70363f4346556443ca6e88de48cc161c1742"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7ca4751cf3b775fdcb4b8c9181166dbfdd5711229521dfe0c333d92791142a"
    sha256 cellar: :any_skip_relocation, monterey:       "533bcf708adf7b6f57d777f2b0adee95be393449bb95d1d433a88495694a0931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c1fc65249f3d5d9cc228fa36f517946167d815b97943bfff1bd2ae78b83861"
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
