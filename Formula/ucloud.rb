class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.20.tar.gz"
  sha256 "3eeb789630ad79605499af48b3b49fe3c95a047f4d0d8527650a0be46bab3fda"

  bottle do
    cellar :any_skip_relocation
    sha256 "a13f7841dbccb37e1d1b2feea75e8162f0692ec2f101eb3bbada2b4d108ce9db" => :mojave
    sha256 "a6f779e5b6a031f2abf091967f3a9e3fb7ea3af01535989298599eb769bf7b0f" => :high_sierra
    sha256 "8383ca8484b86f0376b1284b30ac2da13f1b3dfdbe5b7b47e1a39e876b6175d8" => :sierra
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
