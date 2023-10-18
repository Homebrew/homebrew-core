class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.32.4.tar.gz"
  sha256 "9b7c4886742903f3b0209b96b5cbe253e8fbf99dbd7c82d053657e182f96b513"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3eeea0b51bdd183a1fd75722e3d722e8dd3d043c7e606e073cd72da843c4e63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb96ca5cd8c7d6bc8934dcde8984c5f414504805607746643832e8eafc5e659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdb2c6da0937123217ae604221673035eb33f8ef21eddc3b2ba0533b79d1b4bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "92dd97a6a293c36fc5294f9f29672b1917afb6fc3456092cf7325910470e42c2"
    sha256 cellar: :any_skip_relocation, ventura:        "204f475c861335781c150e5fb752b8c6a4334b06994dddd0abbedca640124f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "8c6b7f33011df8809935235d4bd38a1eb82f2445ce0914a2f4db98bd07490731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be15404b06be5abe10d4e24bb9384251dad0ccf34dcab2a0a899f6e0e8a12a65"
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
