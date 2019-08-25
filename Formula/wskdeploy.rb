class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/incubator-openwhisk-wskdeploy/archive/0.10.0-incubating.tar.gz"
  version "0.10.0-incubating"
  sha256 "c5787a66e24c9fcbe45d8193fdacbb3263056784d8a46695cf05093cd4bf6641"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8d5674fda8507a62dd30b0b26c382bccdc48945c405758c8b805d5350e565aa" => :mojave
    sha256 "3569a4127a3503f8507d5b437d0d35c4c5a259055f84984553d83a6ad9be42e0" => :high_sierra
    sha256 "0cd26ef2912f60d108795fb7588a81edf6a1c937e90a2f8ba4987926376c0cab" => :sierra
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
