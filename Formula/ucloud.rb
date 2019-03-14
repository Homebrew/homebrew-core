class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.12.tar.gz"
  sha256 "c31bb2ff7abe4bf2d97e152676784edeca1c741868db97c75f18227f0f2914b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2e48e9d196b1d5dd9868ec64a7d4d81185724e78f050aabd29c400b4ede38a6" => :mojave
    sha256 "caf015116b75a6401f4d274b12c12cfc96313e2b5fe2b0e1977d43c8e6f8040e" => :high_sierra
    sha256 "526fd2b4dced016e2fdd9f523383832b39d5fce65f190f1b0b8d6e5d05e16902" => :sierra
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
