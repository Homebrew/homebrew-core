class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.16.tar.gz"
  sha256 "177f035a3f9ad3c82e8a3136fde9bf045f300edead02a5ed167d1c29a7229a53"

  bottle do
    cellar :any_skip_relocation
    sha256 "dca7ed23059c3b87e931f45bab9c31234de030f135b42291bb3d6279830966bd" => :mojave
    sha256 "983dc559f7e03c0b578c28ae24f05a93243983909e92c9032f78fae1eb620ef9" => :high_sierra
    sha256 "1ecdd6f15dbcd2fa6dfd1a74f52385feaf673648f6cd9134ad8b6a0486569a17" => :sierra
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
