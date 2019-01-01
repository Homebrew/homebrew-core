class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.7.tar.gz"
  sha256 "e1f6870bcd2e9c1acb4a8c415490ef1c7d5cc65a35e745c339e9b3a391db159f"

  bottle do
    cellar :any_skip_relocation
    sha256 "96d18c0e4546516e2e842d249f9e07e87356a1f2f9968de83e0d863dcf9c204a" => :mojave
    sha256 "e190b11724029c31e83f6371dc662fe330f1f31ae6ccfe51ab7a1bc6c67ac0fa" => :high_sierra
    sha256 "3feed318f4057faafd111839f7bcc1d9046931429f5123d708154c11c0ba172e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
