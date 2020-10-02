class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/1.1.0.tar.gz"
  sha256 "caf1f147c363a7324ce0c5d9851794c5671f56712888004c0db644de8f2a2169"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3628415e19ddfa9aa4c701f10bdecc2b60a595b8a88beff1fada7174b38517ed" => :catalina
    sha256 "fa27eb070527a3e4fff0ea62ed16e521b2c7f5482f4ca8c1bb934823e75c856b" => :mojave
    sha256 "9690c45ee52ba2c4bee9de7075136fd6743f05dcfca445c57f44df940b1fb3e7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
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
