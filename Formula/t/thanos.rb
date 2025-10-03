class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "107d1976d5e7512747375770ed3efc92168a33732dcbb2a3fdbb4ce339fa7c9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03d4044e4134affa7a576169d773e19bda2dcbb4a23fde377aebea57842c93d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d777958f5a190f2452165e581998ddd14f3e20648540cbbb65c37cd38e67ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4935a9dfd7f35ceb40938830679b19de5deb032b3313a4a0d1a4be17d9069c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "025c060a2c3fe17f1ed2d50a08f2a381ab488668dba3aed50129b4f463e29235"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b0ae9f86bec8fd1d12d4f90417b008c98cec19d611ae331f09f187b2cb370bf"
    sha256 cellar: :any_skip_relocation, ventura:       "6991dc6b39a456d814d923195c8a1df5f2cfa41884982d850abe206649bffc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27308a942580a9b5c026a1a4086f0b41ed076cdc6e6ee0b1d75d7982ab72e52e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
