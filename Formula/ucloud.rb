class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.5.tar.gz"
  sha256 "311af69c744804eaef936e5d7c00cf17c178fcb4a2d8c179f99b0694b8c822b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6adc62a059cc18ec845ad6742cd8061c0a3248c9277ac544b61987d8d23d8df" => :mojave
    sha256 "98a66d4be082e582f23fc39ce091007eb65c85618c39d7a548aa9c679008f86a" => :high_sierra
    sha256 "b2ca54a504052833ced181fe1f7c9adc6ed4682ad6ef7b1a5b3c5c4b837c7b1c" => :sierra
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
