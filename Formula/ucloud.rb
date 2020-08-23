class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.32.tar.gz"
  sha256 "7a461726e53edc141ebab94aa6e4957c64eb8edc44e1a6bc41d29b0e913dfcb8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "64d956c8d49a0b66d8bd06b63c305c83ff3b8102c7071f3ab354ec9d00548b99" => :catalina
    sha256 "5f450755e1e86a66268739cffb040cd028b57bdb8ad7602e761d3778c17292d1" => :mojave
    sha256 "d8d2c7e981ae2900decacaf0623639a2cf221e969f084e6c7d37a0bd18608dfb" => :high_sierra
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
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
