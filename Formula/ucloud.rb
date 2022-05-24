class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.38.tar.gz"
  sha256 "466197235a2d9ff5a66237813f040ef6cd0efeb9513b578bfb6b215663640b9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ad481bdabbeefaae3deb57e042a528c27ce53de516cde97fe3773d3afce446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4254bec5ee25cc98a01e1cfa0d62ad68c02cbbf3369d9fb9e20b3e9a6785326a"
    sha256 cellar: :any_skip_relocation, monterey:       "82824c4f847acbc5f1019f639b8835c43ea73f8846e6798ea001877f9cb67a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f118aa482175e143131d1866b739e553b43ae64e0c7575345804481fc5a9cc4"
    sha256 cellar: :any_skip_relocation, catalina:       "444e0fbaf9dcbf1a47a762621e0139fa38e240a77ad0a11fa563b463b07a6adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261e26cb2a77389f36b808b046d42a968660bedd2c30535ce5a12ffdabf98331"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-mod=vendor", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
