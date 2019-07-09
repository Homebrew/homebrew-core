class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.19.tar.gz"
  sha256 "43a6b40520d882d90b7231dfc6afd532e3a98e8572a288068144225db9836104"

  bottle do
    cellar :any_skip_relocation
    sha256 "53cf26488c81670abee138b6c2baf6904d3fba80fd1302261eb69359f50a19eb" => :mojave
    sha256 "d2b96bb4de1b567fa6c88f21fd2a6ab7da03b6dfa0145de5794714808093825e" => :high_sierra
    sha256 "94f2757288358a5503e3b1a53762816a03c60f219a6459a6ac0e7ec6e6b1362e" => :sierra
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
