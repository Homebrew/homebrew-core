class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.14.tar.gz"
  sha256 "63ecd4be5750045889685bd51f2cfb508e8176278347068dd603bbbfe08fa958"

  bottle do
    cellar :any_skip_relocation
    sha256 "3625008f28ebed6dce908ed40f23b77603d8718cf2f075cf8ab55af4171291e9" => :mojave
    sha256 "f6eb0a195170653990d3ccd1e2409d3f33520a12f91a5dfda32c6697951445c4" => :high_sierra
    sha256 "eeedf3b122ec46f6c4507deece4a4a35ea13c669c7ea54d8772fcdd905c3d311" => :sierra
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
