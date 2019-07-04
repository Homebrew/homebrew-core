class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.18.tar.gz"
  sha256 "ed57f68ce795dfc31dff047555c2aad70fdd6d9ff5528773c1d0ac57037f962f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ac61e42a536f0911b77a6afab5da33af43db5c6723a582bbf13d9077a039dee" => :mojave
    sha256 "b137090d8c0bb6ae4aa49f66cac66e6cbc98cf9ae2f5cab419e64c0e305b8f76" => :high_sierra
    sha256 "dc32d2488777be54e59ec8b5169c25ecd9a766c2b6a9bbd32c7387a3b4457a13" => :sierra
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
