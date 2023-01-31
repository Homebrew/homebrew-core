class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.30.2.tar.gz"
  sha256 "0d76a51925b35737716ca41fc08699dadea1fd5feb9effbafa4e001205e7ccf9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ecafc7dd37b366acf36b2cf28e165749bc5a6c7c8262150e419a527bffbaa93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d8b4b3a0c4674c1387f44c71a54978a9fc0ea6d2695cbbf1fea3c41bbcda37c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f5d0fd5372709734804a1d36d4c052b07b46de3e4bf7b57a3b65b0082f5898"
    sha256 cellar: :any_skip_relocation, ventura:        "c359d2cd68c228d80174d6abbc36897f530d87622ab3d14381b7714182f50ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "85f7ccfb8adc30c88be2f5ab5f414fb28aceb4745974e17080cf7923aac24f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1728b870b871e555b11ade159dc2eb5bb69a175c00a5ba34da1746b01a1fb624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5416ab6e5ed106a56f1a703928993f90bfc4f7fc0b84946b82a0a8875de184c2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
