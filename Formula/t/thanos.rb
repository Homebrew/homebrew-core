class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "e62a344b03640f2ccc402d9d330c21d64f038fd712a613ef571256a4005fc8fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28fa27303883504fd7221f63203b9ca100712aa9785f6326045f3bc9b47163fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e9d12dc921858d376746ff7cd40cd8e9f6f068dcda84caa11b8435408305f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad4cdb30f6b17591417904b84cb62f8fafc4c73da60adec8c353e8901c90e99b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ad3594698ef72b76929d168b0cc328275dfd25f02e856605b9bfcdb8c7c8e3e"
    sha256 cellar: :any_skip_relocation, ventura:        "be977bf1a8590852adca8e86389a610820f39a984dd4ba2e57346a5b8c2ad86e"
    sha256 cellar: :any_skip_relocation, monterey:       "f8196d852b941a44956eb5650b52e956b2a73f8a4aeb06e0db2d24d3598b293b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9046aee4105eb63470fccd1101a3a4b60e505e8011ec531329cff67dd0e82e42"
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
