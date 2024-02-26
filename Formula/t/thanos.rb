class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "511090dcc7e6a0a8fb4e7d9b07aa9e0f16a58861cbb86f04dcad2758816f3295"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "601aebece1734f6cc14b63907e05b6a5a17ddd9583162f1cb367635299b27538"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "955fbb8ea5d58536284d461b7211622171999c7c414aaad4dca9f8fd00234f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c4b6a99199242735b51fa1611414b44f39c1a9b11d02d9cee743c670ea0df5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "449a0d309aa17936ef7878f870b7ab169ba13e4d5f21f97cf43f88c83b5e11f0"
    sha256 cellar: :any_skip_relocation, ventura:        "bc2af5e0eab2050ef22b60e0d99242558a82829022539a2c6fed1b1d1ed4267e"
    sha256 cellar: :any_skip_relocation, monterey:       "ef084fea3a456936caa01f783b70f6b8ab170f921034c1ac6041b8e0dd7ba60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ffc4bb1793ec9b6a778474c9dc441ee8abc73c3fca6a04f77309721e8efa8a7"
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
