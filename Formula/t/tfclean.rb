class Tfclean < Formula
  desc "Remove applied moved block, import block, etc"
  homepage "https://github.com/takaishi/tfclean"
  url "https://github.com/takaishi/tfclean/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "3e4e0abfede86e3e69a83bf864eef84aa83f06f0795ef0bcb0e03630ed6e3e06"
  license "MIT"
  head "https://github.com/takaishi/tfclean.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2b090816f35818d84b90572f83d1194887d0810659dbbd1bb1fd927c72ae2c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b090816f35818d84b90572f83d1194887d0810659dbbd1bb1fd927c72ae2c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2b090816f35818d84b90572f83d1194887d0810659dbbd1bb1fd927c72ae2c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "009f46117f78fc2ef5aba5d2ef04567329188e5128ae965db103ebb0c968d0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f749a5dbcf34185fadccaed25725ab22e53d577e32b938eac6f76a1b0866123a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e5e7bb7a06ca35ab87da7f3bc2ed7daed00b99ecea4255205148e588e8c386"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/takaishi/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean.Revision=#{tap.user}
      -X github.com/takaishi/tfclean/cmd/tfclean.Version=#{version}
      -X github.com/takaishi/tfclean/cmd/tfclean.Revision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfclean"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfclean --version")

    # https://github.com/opentofu/opentofu/blob/main/internal/command/e2etest/testdata/tf-provider/test.tfstate
    (testpath/"test.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "0.13.0",
        "serial": 1,
        "lineage": "8fab7b5a-511c-d586-988e-250f99c8feb4",
        "outputs": {
          "out": {
            "value": "test",
            "type": "string"
          }
        },
        "resources": []
      }
    EOS

    system bin/"tfclean", testpath, "--tfstate=#{testpath}/test.tfstate"
  end
end
