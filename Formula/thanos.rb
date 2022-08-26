class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.28.0.tar.gz"
  sha256 "095466b601fbe5c0323beb4b8d93970d6bcb8b2f9607cd5da9514c2d4207b072"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aadad4ecf3e3b3f3fd376b6765ec4b0656d4f307d372a037422cfde845546c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73778b7316f6ccb7c336ab1db26554105a396bcaf494c182947525ccefdcd681"
    sha256 cellar: :any_skip_relocation, monterey:       "b83be437963c722be7ae78b8b8986587e8124a0660bf8a7a07383d7f41e9d0f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a37b690211c8b396c68e4f613127cdbb11927898d5b82166ae5d9620fdc0fc2"
    sha256 cellar: :any_skip_relocation, catalina:       "2a0a34152ceb265bc009d0dc71b1d1748276a052abb05d51f04b73acf1a118b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78c7cbb0b8e2597e3d970fa73caa60dac66ce055ddeeb13a38396734516147f"
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
