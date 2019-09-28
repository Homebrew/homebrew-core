class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/1.0.0.tar.gz"
  sha256 "74c02e8118a123cfad113dc75d5e7d256b18fb80ad9e27b2b95eb74b8677e483"

  bottle do
    cellar :any_skip_relocation
    sha256 "24d5802e44abedb87154bd8d84fd678d99df87afc172238d7a5b0d6b7d650491" => :mojave
    sha256 "a3bc540065d1a8af10d9145df31d27ef9c12165b1b71eb88c24a6b3e248e6b4f" => :high_sierra
    sha256 "2d9e5e6869ec0e2cb319be707845ff0e421790be4a337884649a30a8a8d00659" => :sierra
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
