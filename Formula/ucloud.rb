class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/v0.1.42.tar.gz"
  sha256 "f9f8d44503e4a7d92400f69ecd4c63acf321dea83b26928f29fe16eaf8cdab89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b10c772b1452bbc05aed616199fb8fae60e0f01ca5743d8a14557c16248da7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0780a9dd64ce4cb8218f66b31c854a290ec32158417ce822140c6833886bcdee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2599bbf4de0ea7adf84d3140cea09f3f95f1081b9a7ab11191291c8082f443b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c3621c49ff42d38b5d2f3366ef0ee4b3ad5f0ee8d0d3b8a34a1ba3cdcf762c37"
    sha256 cellar: :any_skip_relocation, monterey:       "887060e6d912c4b5144ce38c3cccd5d13eec319cea8b3fe26e6f5e23f7815fa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3def41be1c5fc23cab4445e0c1419b74693130bfaabe3f9eaa580c8e9fcf391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "509911e42951f94088c4997cbc10813d79b4e19fb7ad2f8b2c67ffbf9eebbb91"
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
