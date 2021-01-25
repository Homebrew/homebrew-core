class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.35.tar.gz"
  sha256 "75d89abe8b6f170a0957dbc1742b060409337161d16988d14a9df8c05b81aa48"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7652d227d29011105ab15ff1bbdce3d3a176afc2ae27c1003746c7a1000f4e7" => :big_sur
    sha256 "23eb0647583f539f176bb8110df100b14496817b7fc5da1860060bea4a1e72bf" => :arm64_big_sur
    sha256 "0e447115650b1cfc4a6149dd83f39c7ca849d740ec430a581be09e8e21adbff5" => :catalina
    sha256 "e5a5bcfec828253269cd75c1f0e7f6d606748a4b4d5ef987088581f7b5425e17" => :mojave
    sha256 "e7208d9e0dc5db081191c336d4e11ad44fb39d98221253a9577f6c2b7de3a374" => :high_sierra
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
