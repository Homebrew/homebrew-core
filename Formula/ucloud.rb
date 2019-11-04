class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.28.tar.gz"
  sha256 "d5b1399956361d1d89c634c3067a7bc22383be577f8f9f08d671d181265bee2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a12841f90cdb9efb22b7cc07e59913f4b7e0bf5e0511b4282490108b3c6555b" => :catalina
    sha256 "fd1eed27d7636c674225a252bae6e39a83195c2e8dbdb23b6246bcbf0067c160" => :mojave
    sha256 "99c901c1360323066e6b447578745b54a7832cb0bef28af84a717c03c733ed50" => :high_sierra
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
