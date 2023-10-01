class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "1cbd18fac2b89c1e5333f95991943be9647a49b7bdff831956825807c7c870fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84bf4f336b1f52527e18c207bb1266ac7a196f6dee50da5d09fdce954a0429c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "114c35e22f6f43c77488da7880c6a7e322d781be769a21f01895b7de91777392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b34a4ee4307ad033d7093d630fb91af4bc79db0db97189868b2cd1fcc3390db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d1227a83e2fb057eddda9a629616ea6687aa253cebe977e5bbae0280f812db3"
    sha256 cellar: :any_skip_relocation, sonoma:         "48707b8fa86394cae4d5f1dff42f18981abb5ff26fd6a15c313d919f1e357cff"
    sha256 cellar: :any_skip_relocation, ventura:        "c8dd95a9673fa47c5ce31c01687d964da80041b15fc8ba733c0672de5b59dfa6"
    sha256 cellar: :any_skip_relocation, monterey:       "befe060a76f0ab46f3d96dec470fc676bf69e011a2797179cd98515c02c01575"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc7014fd2d13beec84503fd0dfdaef532f20eb451110785d6f07301315320e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9208602bc279d1f6925ff749d28e3a9eb1ea58f8c5a29eba5a77238d842fe963"
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
