class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.4.tar.gz"
  sha256 "594f8004cc688a857c87ac835b4896c29085d32f139f04aaedc4544eedf8650e"

  bottle do
    cellar :any_skip_relocation
    sha256 "449b424b52feca02e681025fb262b705f11641b2ab9dfeb2a5a489217333ee64" => :mojave
    sha256 "6f28e8b6951e793c58f125a3963c7ebd732cd58e78bfa32f8ab98cc7fdc3147b" => :high_sierra
    sha256 "f02e4c51a628f9a311dc75cb75fd0cbdebbdf3f864b6478314079758fce91d65" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "--project-id", "org-test"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
