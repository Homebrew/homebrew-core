class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.42.4.tar.gz"
  sha256 "0f078dcb6d47bde6b3de0e962355d977f6fc017975d882531c4bd70f81f61fae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f78ac7930b09f4b5da8dc62ed4c53cc52bb5e7cc72a9733e8771fa9a43fdca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dad1ff546561ce1e703d5a59c22ce3ab707f9ad3e3c0de7fdde44a87acdeac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef94b7eadbe0bd030f0b228141ad0e475b6a8de49099436a7ba071332fa2a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8c2e2b4f814164b3f1cf83a2fefffce4612e2d4026f33ad056c959ef3482306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f53b1f6a5e60784d352cb8b63b74f830640a43eec615d94efe32d8df0d71f6d1"
    sha256 cellar: :any,                 x86_64_linux:  "78bc5e297dc8a207b24e80ac7f7fd2232b03cb7fe7881c84652d4b6cb43d0599"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
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
