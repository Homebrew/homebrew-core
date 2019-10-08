class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.25.tar.gz"
  sha256 "efe5d04d9326ed258d7a9f6f53d46e65e60cd8473094e6ff2e9a46a7d62ef28f"

  bottle do
    cellar :any_skip_relocation
    sha256 "69a4efcf6e3bfd46d4117901054a8f5a7789de6d202ff4c423e3a5e52b5b7750" => :catalina
    sha256 "e67cc28ba697389dc4e3d2869e10cb85e5a3dc6484a785c9d7726d5f90225543" => :mojave
    sha256 "1c64239f9144628f45141d0d7edc0ba5a43729db11c3f02dfab3494aeee1f4e7" => :high_sierra
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
