class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/incubator-openwhisk-wskdeploy/archive/0.9.8-incubating.tar.gz"
  version "0.9.8"
  sha256 "10ff548bf43448d734e0e6f4b6aee8d306759a4ff8a5a7deaa61329c0f3376a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "af115b7e657349574b92dffab3e7609fbf60706fb9dc9ae1c6a030812e21755f" => :mojave
    sha256 "6b420b7cfe07d10a7f37664dd2e906bc7a7ef0e8d9e15124ddaaee0ed7846d3d" => :high_sierra
    sha256 "e11f904c7afd3555efabcebbee7bfba2957cbbf157279f37c77f070185715080" => :sierra
    sha256 "837e83f970a1ad4951560d37937b30a47b162c17700ee03838f642a18c355e55" => :el_capitan
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
