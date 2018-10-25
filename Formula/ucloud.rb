class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.4.tar.gz"
  sha256 "594f8004cc688a857c87ac835b4896c29085d32f139f04aaedc4544eedf8650e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a8b517717d359b92bcc5b23328dac28a18feb922a154eabf0c6f610c4d8f50c" => :mojave
    sha256 "110cd73ea117b317a50e4dc495af69945694b2aecb0fef06d0d30098450f9e2e" => :high_sierra
    sha256 "62184554d8df97d63483a646055b56a5e5b0c9890a5e1c4f7969a59b81701e0e" => :sierra
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
