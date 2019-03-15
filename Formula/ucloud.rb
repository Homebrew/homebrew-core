class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.13.tar.gz"
  sha256 "0bd2a5a1bebc5b9e64979a1ad8b10e4ee4acc0e73954f489cd6e78378d1010d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4aeda37eb2dbbd9cdfc6acb5f0aa3ebee336bb5122b2d296b4ebd34b3979248" => :mojave
    sha256 "139dea34069db462dc7cefdfabf927e06554532fa805146bbd4f3eeacdbbac33" => :high_sierra
    sha256 "dd31560ea81c71aa693e4d61dc6bb4391aeff48d39a002ca54ac28273791fdcf" => :sierra
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
