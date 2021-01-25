class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/1.1.0.tar.gz"
  sha256 "caf1f147c363a7324ce0c5d9851794c5671f56712888004c0db644de8f2a2169"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "79a5cf98448c501d441edcd2bacb5c84cac9a3a7702ec8f9d3aa78ae05dc586a" => :big_sur
    sha256 "681984dc7d97f45477252e42ca8dd8a3cd8758f274bbf8d2cc92613dda4f023d" => :arm64_big_sur
    sha256 "ea50064881e77fc755335751edfbd5a37d8c858d77dd6d9fc336be3af3fdbc18" => :catalina
    sha256 "90b92ae3d73e3bb529b9b777e43842accab85e0dadf5b289d6c3eefeb15377a0" => :mojave
    sha256 "4cdc4d3314a16347a1f22367d5a21590ddda64e67fdeb015f050f9d14f12fdf5" => :high_sierra
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
