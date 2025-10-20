class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.155.0.tgz"
  sha256 "70d24e8f9c181dec4742a32560f22f126aa6fde453d153f4d9b2365eca393367"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffe4735d820a10e570ad3000acd8586b2039588f70637a7ccd30dc0b7aab3c8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3489163d8ecea02e57f70e6532ce410782f2655ab10f52fca288ad577d813239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c773adcc247f3ccda98536697011462d7d63e744729385f34f069aa75da7d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd60c62927dce23cd0b0d0c1ddb7149a782395513fcd2b1491cdfc747654be09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33bd46c86444882deb6a77709189a4d67008c355f5e1d260ce4b2ef703826c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bead1f69785ba70b418b664b768230b66aa0821e92457e184f7c4f03ec505eb"
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
