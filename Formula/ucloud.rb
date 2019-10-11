class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.26.tar.gz"
  sha256 "a1c170eb16ee0da4b8a7fa407af0486ed54394086f45dbb8bb374db7416c81fc"

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
