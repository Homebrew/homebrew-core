class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.25.2.tar.gz"
  sha256 "c77fe0ec6ce596506fd200548ec90dafe0bd268cdf0e0fb965a2ff2648b18e03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08f0d3ca8fd91901eb9921d128ed9c2cb56031b7ad6fc3f40777e1f77d4208f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59f871c253dfe4f5da119e491c212f74e6862a927aa6778011b4d2ded5f77b49"
    sha256 cellar: :any_skip_relocation, monterey:       "10b1cb40a1fc3e3ac56398d8fdd1b147959aa16cdbedd651e1f257c8b407e8bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cc1b9f51f459e0e29ebac470bb2ff6a0563dbc3f6d447d21c91554ddb80bfe1"
    sha256 cellar: :any_skip_relocation, catalina:       "3a783c6632fe556170152f67081c7aed03e93b5461d433a7f4b56857304183f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b92f8ac455c5a43fb57b5ff06a9edf9b252f1fa2c395d3d5e4dda7ab26ef116a"
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
