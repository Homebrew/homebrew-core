class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/1.0.0.tar.gz"
  sha256 "74c02e8118a123cfad113dc75d5e7d256b18fb80ad9e27b2b95eb74b8677e483"

  bottle do
    cellar :any_skip_relocation
    sha256 "3628415e19ddfa9aa4c701f10bdecc2b60a595b8a88beff1fada7174b38517ed" => :catalina
    sha256 "fa27eb070527a3e4fff0ea62ed16e521b2c7f5482f4ca8c1bb934823e75c856b" => :mojave
    sha256 "9690c45ee52ba2c4bee9de7075136fd6743f05dcfca445c57f44df940b1fb3e7" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/apache/openwhisk-wskdeploy").install buildpath.children
    cd "src/github.com/apache/openwhisk-wskdeploy" do
      system "godep", "restore"
      system "go", "build", "-o", bin/"wskdeploy",
                   "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wskdeploy version")

    (testpath/"manifest.yaml").write <<~EOS
      packages:
        hello_world_package:
          version: 1.0
          license: Apache-2.0
    EOS

    system bin/"wskdeploy", "-v",
                            "--apihost", "openwhisk.ng.bluemix.net",
                            "--preview",
                            "-m", testpath/"manifest.yaml",
                            "-u", "abcd"
  end
end
