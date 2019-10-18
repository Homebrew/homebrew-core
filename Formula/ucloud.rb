class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.27.tar.gz"
  sha256 "a21e05fe2d592f04296f9d040b128908f08af58e88aa61f526ee992474ffe3e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0cbdfd78c81915ff0255631c32cbed943b53afd347af9f675ad93c43c6ede90" => :catalina
    sha256 "f90d802950a62dda6dd444af5aed73eb9fcb7707d9af989626054c89f0bc8163" => :mojave
    sha256 "dfa167ee65df70a51f84cf53e5554242b35b97e9b5c8bf654c6f52b507965065" => :high_sierra
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
