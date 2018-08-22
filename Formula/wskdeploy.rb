class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "http://openwhisk.org/"
  url "https://github.com/apache/incubator-openwhisk-wskdeploy/archive/0.9.7.tar.gz"
  sha256 "15f586aeb3221e67b583941b988fcc572eebafc64c58d4a2df2787007344f064"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbcca1feeecc26d9f62340e5c46cda27ec091b27f20706aa41801fdb9fa6d4c0" => :high_sierra
    sha256 "7595301f3c9537a6c783e192e845ef02fac4c49b79a0fbe391dcc814d55e1d92" => :sierra
    sha256 "daa53af3f825acbeac28e02cb5cedec6783b436667273d4d7dded30f6485c145" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/apache/incubator-openwhisk-wskdeploy").install buildpath.children
    cd "src/github.com/apache/incubator-openwhisk-wskdeploy" do
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
