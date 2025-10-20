class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.154.0.tgz"
  sha256 "e357033039be28ac4870d0f3ee25f3ef28fe4d5b346907e74eb3756fd4b135c5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31b371d89c836f47547290c0a9018e560795855f1d34fd4258f427760ea2865f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67439d5f09421808099f166414b7732ecd609ba3a9f285126dbd77b5c800f536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c27e82bddab85019bfda9b2f8b2a5a175223059ea3e5618f8e5f16f48c58d412"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1bd5029466c01ab9e184aa656f48db0092168ad827b71441ea65ec0333ddae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0532684c309ba57e8f843cec9302e39447617c19d9757bcf98f5fc583fed6257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c566f1f4e9bb6c3069953a74f172e5d77290e8e7f0d1f6825fab47f8c97f8533"
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
