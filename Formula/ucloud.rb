class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.24.tar.gz"
  sha256 "29f853384bd1239de3a9d43135911c0400d4eb2a51b1018a72465d897e1e18e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "48f32e98ba3bce2f3b32c6f0e7a39e715b320dd78b8fdad47407888f332ab1c3" => :mojave
    sha256 "4835c65579950c35747cf0536ff955e278709806a070afa0d8bda1e285a68d9c" => :high_sierra
    sha256 "0e59ae1f36878badc68aaf10f74a31bb695dd61bc71b98aceffa62686f4398b0" => :sierra
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
