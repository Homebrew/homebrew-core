class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/v0.1.42.tar.gz"
  sha256 "f9f8d44503e4a7d92400f69ecd4c63acf321dea83b26928f29fe16eaf8cdab89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac226f7e5193f75b818728005f902b259b3b77b3f7d19bf761db00f2b572504e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "930332e36a9f7a519c422a3df7ad0029c3514d2d6ee707affe35e4050b75641a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a640ce9022d66f91ec8c9aa147744e18ef0720a6557889a713a153138a40fea"
    sha256 cellar: :any_skip_relocation, ventura:        "1379001c74bfcbec5e0faa227248e6f1881dc11dfc9bad54abd788fd9b9d1488"
    sha256 cellar: :any_skip_relocation, monterey:       "0264bd58bc9dd0642dcf29e6c78fcd034eeec09f565282ab26390fcdd2b42df7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9319f4f3553bd0ceb4130db60b3e8d1ccc8403f8b8865c885910d21ce1ed9482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92e0597cbc76097e9f06d4376e433f4224f23e2e42dd4cbcd74bc876c058694"
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
