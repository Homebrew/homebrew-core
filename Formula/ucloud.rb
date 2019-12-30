class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.29.tar.gz"
  sha256 "aeb4dce325aa2a9918987026a7548aaea4564fde58e8468b108008c92cfee5d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "74252d770cdaffa85614fb58d679bed267b35b1984bee75f2f37a73926430074" => :catalina
    sha256 "06b81238bdf4c69857974350474000353847d4d5e880661fa01b99b7ed12f364" => :mojave
    sha256 "419a3d47d5f5a8fb1a197a1cb555edb7dc9d0ff7d843fb9e4816bb669d20139e" => :high_sierra
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
