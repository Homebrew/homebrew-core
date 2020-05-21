class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.31.tar.gz"
  sha256 "c6401378c14a6d6101323220f8ff4ba273230ace4bae8d5e061a6be4a58a2130"

  bottle do
    cellar :any_skip_relocation
    sha256 "67634cf4ef694e432a9bd5f991cb11b39779297ea0d2d50e295416e130026c97" => :catalina
    sha256 "f12f90529a80094c4703e3d1b1ffcf1823d62fc9e75454d537028938ab079440" => :mojave
    sha256 "93ff47384635ac72c16afd8fbea859cabed9542359edc0fc2be41ac852f3f868" => :high_sierra
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
