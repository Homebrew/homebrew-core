class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.23.tar.gz"
  sha256 "a7d4ee43320e31514b17d6deb8768da2c2a6c84dc741c20082bc98683b3fde9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f64a91d4c9d7ccd461b50b0633dcf213205c1977b90eac63f45ae9b9405c788c" => :mojave
    sha256 "c45290e25dddc955b3720d736406f2e9f62ee7a393b23b029d9340d77a345add" => :high_sierra
    sha256 "2a0f5472de04428eebf2b89277d58a85b7164e4784fec94180e526b1aca3e8c5" => :sierra
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
