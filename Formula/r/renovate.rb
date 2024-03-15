require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.247.0.tgz"
  sha256 "9784873093cace07cac0e551fa0531a66f1d5a05d4775cdfab64d519e840d2be"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857e452ee045a8d6a79c4c75d4fb58e435d65452e431abda37680a92bb5a1ecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11684c3eb6ff0c349909427272230beba89564850942267650d4d211bc44e8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb4306bdb6ecb01e7a413acf71a156c10f56ed7c6133edc3d3bdc59f0fedf34"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f5ca5cff2e28a705104fa05ab2f03ca6b3d89d21d49b7cd3a33ee3275658ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "051ca845d5068f6c865c691ef59b0bd39e3eeae4f1701619c3e38390cff10074"
    sha256 cellar: :any_skip_relocation, monterey:       "33c0ca839a32a1972aececbd977b5619ede00e5b45673398567de61c794cad2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04186b7693b64a3baf0379d6192513267decd6e76180eba0ded3b977d8e2cc93"
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
