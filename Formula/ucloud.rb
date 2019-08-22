class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.23.tar.gz"
  sha256 "a7d4ee43320e31514b17d6deb8768da2c2a6c84dc741c20082bc98683b3fde9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e71074df329f9760e1cc7efa162015c32c73b415fc0f4dccbdb8f126dc554587" => :mojave
    sha256 "016915572dc633e8ec55eff27589f1dda73b086fcb7a07b59e3fec5653ed3bf9" => :high_sierra
    sha256 "f5acd5e0dc5e3d3c10799830e09c94c92ecc0f564b9bb423deb887e9df81c3e6" => :sierra
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
