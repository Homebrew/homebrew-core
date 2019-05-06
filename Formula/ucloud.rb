class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.15.tar.gz"
  sha256 "68cbfb71c018624259ec04dc42f494151bf42d583a252f57dd6d78120b52ce78"

  bottle do
    cellar :any_skip_relocation
    sha256 "08026f337b9c5607eef29fead70e1a4ebb50469f0bd86e6fcb6740545955af90" => :mojave
    sha256 "e460566b0d9d90bba153d8157cb14c065c27a050b356d098f5efed2b15c48f79" => :high_sierra
    sha256 "95fe9ddeae7a301357d83b547def718429edf7822525684f06b473f18b854f37" => :sierra
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
