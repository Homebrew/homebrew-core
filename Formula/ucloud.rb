class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://ucloud-sdk.dl.ufileos.com/ucloud-cli-0.1.2.tar.gz"
  sha256 "f41aaa6bf8063b3ccd0c5e41d3dc90f46f9fb45066513da8e306456f1f332071"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c06cd38566d23fc3cbe34fe5a26b6212fc6f1cc2dfe73552ba90229dc07294e" => :mojave
    sha256 "d65675203d124f39d9d45d880604e63bff3234bf8e98373e176588f7ab640ca7" => :high_sierra
    sha256 "6a60ad6f58e6aabce9b23924f6e5863702f090d3ca8a940b4acdfd368958b799" => :sierra
    sha256 "0818bc13c03b59ba6189deda71d3cdfefae07670cd2d978c3a30f79b3b793fb0" => :el_capitan
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
    system "#{bin}/ucloud", "config", "set", "region", "cn-bj2"
    system "#{bin}/ucloud", "config", "set", "project-id", "org-test"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"region":"cn-bj2"', config_json
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud version")
  end
end
