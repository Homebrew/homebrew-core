class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/v0.1.40.tar.gz"
  sha256 "fb6cdd5e7291a0439d9ec5cc5403cbfa1b504fa92c576ba7acdfb2d561d92b40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe13e3873b5238b391eff28a723b78d7efba937e6e12c7775dbde1a978f8a2df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be739c5a28212b1d3b38ed7703d9429b3918c1827b26abd02ab2c4e311bd60d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c453634ad09c1ebdc8525b9b2e82668af044b8c619880b72adb5fc7b89940297"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0695c00458fc3e849b77947782a191effc3c7933d67c9ebefc4d2bbad5290d5"
    sha256 cellar: :any_skip_relocation, catalina:       "41da7a34c266e528be198b7798dd94c92354f80e37bf6dc8bf3d4bd14e8d8e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80e2fbdc7a7b717b71d2704fa7ab24b769449304091d8e00aa3b48fc4a22b920"
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
