class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.18.tar.gz"
  sha256 "ed57f68ce795dfc31dff047555c2aad70fdd6d9ff5528773c1d0ac57037f962f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e588dca690bb1beb90dca8c9b66ba9b969d670f08962ecb0ce432e68efcf2ce1" => :mojave
    sha256 "8678a8ed80d855754b592db3e4b521b2a93f28a6994ddccb71da8c9304d51982" => :high_sierra
    sha256 "5dc88f846bbc04989fc4ce10026fc741da4c34d64342778b4d9ca49b8c353f13" => :sierra
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
