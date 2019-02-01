class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/0.1.9.tar.gz"
  sha256 "8abc4cdc3fc0130dbe9ea44c5f4a6ce3603be85e674f3f0f55bea7e13a8376f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f01a660731454d70083bd85c2c35dd51bead5650becc0c6e16bb206e7270bc8" => :mojave
    sha256 "7b3a1e6e3fcc6da4c5a907a284b9e91186ff453b00c1f37721dcb4e36c0fe113" => :high_sierra
    sha256 "7512d599d18c4aa5a48f5e6c9c1a3855c076d1dc3efc2cb89cf976676a1220e4" => :sierra
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
    system "#{bin}/ucloud", "config", "--project-id", "org-test", "--profile", "default"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
