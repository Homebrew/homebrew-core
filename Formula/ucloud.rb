class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.29.tar.gz"
  sha256 "aeb4dce325aa2a9918987026a7548aaea4564fde58e8468b108008c92cfee5d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "97acbc871acb59f61ab97b4c8640f62e42235ab81dd3ff8ff06eafb0c4ec68a4" => :catalina
    sha256 "5afa42204cf88643519ba5452d71f35f3f81f01ac151ec2b74c65295a6db0840" => :mojave
    sha256 "8d44512d30c58b0337e0d5e04556edbe437da4289becfd6a69bea2ca42ea382d" => :high_sierra
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
