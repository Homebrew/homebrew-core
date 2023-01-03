class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.30.0.tar.gz"
  sha256 "6e18d9f032e9f0a7735259e367aaa528b2339eae5eafb18af46049dceaa7c13d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4732a2e5f1f62da00c912ab14ef7a9d869c082fbab6f3eba2c6a80601ebb64f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7162659f51421e0de895ff192b0b379b5567c70a4354db4bd39394ad783266ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb9024fc888608b0f91cb7ddd012a7160bdc2779faeac3653a9e0cf848e74c57"
    sha256 cellar: :any_skip_relocation, ventura:        "d308aff80bc766a608fd832d4bf88bd6cbd3bd53924e617096f68b0914af24cf"
    sha256 cellar: :any_skip_relocation, monterey:       "fcf70721bf3a6e4d8dd36c198ebeec2c91314b34458eb05e7bc82306746d28ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1ff1007ead5a6527dcbf5e4ecd4813b944d08a6d70a62c1117def618e8c29e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea0fd96d5e6bf41e4003bfab93f8e5846607b93f5597ddd93d3cdeae04d690e"
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
