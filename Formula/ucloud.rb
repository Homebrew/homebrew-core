class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.21.tar.gz"
  sha256 "c56243060366c45befe36fcf598271e1d4eae484020507b51f4c5fe126835633"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e1de1386c7172494282b659cb1d7bd7f1821adac654725a60619c50ccbeb3da" => :mojave
    sha256 "117f1f5247f08fabecc05b005d60e6681a5cc5eb0008f5054ea9f4756de3b590" => :high_sierra
    sha256 "913aa66bfc157af5f7df75682d5f31de60d7a1fb514e7679aa1d8d612a64414d" => :sierra
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
