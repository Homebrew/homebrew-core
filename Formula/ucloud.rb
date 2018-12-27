class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.7.tar.gz"
  sha256 "e1f6870bcd2e9c1acb4a8c415490ef1c7d5cc65a35e745c339e9b3a391db159f"

  bottle do
    cellar :any_skip_relocation
    sha256 "72796aac9a67941312b86eb33e6c911970d9545ea1fbe132089eddfa1c90d81d" => :mojave
    sha256 "f3e7a8de0aede8cc6b75a87bb2aa57a86f36ca442e7cb56774cdc9af6577cdc8" => :high_sierra
    sha256 "be94be41608cda1625a387f2f5922524480cb168d3ddb236076438a334343fef" => :sierra
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
