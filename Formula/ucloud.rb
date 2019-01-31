class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.9.tar.gz"
  sha256 "8abc4cdc3fc0130dbe9ea44c5f4a6ce3603be85e674f3f0f55bea7e13a8376f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdf812d40e2c01fee77b5ea9711926578997a9cdc7a77132209a541f6c6814d7" => :mojave
    sha256 "ba282439388b4eb3964455be63b85304838548b56907dc5fe84ee246056bd4a9" => :high_sierra
    sha256 "a11eaa78c9de05bb4d6cd5e948c22d62e9fbe633cf2db04e9c73c7962ea3986b" => :sierra
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
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
