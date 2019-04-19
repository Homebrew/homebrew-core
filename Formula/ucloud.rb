class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.15.tar.gz"
  sha256 "68cbfb71c018624259ec04dc42f494151bf42d583a252f57dd6d78120b52ce78"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bfc09de816718339f2f0d3cd21c59046ef4d44a089ea7a115a0999016ad5825" => :mojave
    sha256 "19cc2ae5483bebc90ade41bc716cb00c86942e21c7d6340d6a71aa3e00fc10cd" => :high_sierra
    sha256 "d01218092f5d74abde518003ad09a6b2c84b75bdf18a21649ca7b5bac7675120" => :sierra
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
