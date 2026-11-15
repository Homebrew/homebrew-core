class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "61a91cccc4fb400603ac729f7d9116f797f252eec7613eefa935ac6e8f976609"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b7c4b19af963a94c5a3d5da625af911891bb6277ebff266dbc26db452f00044"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a167f10a4652d4e2bb8cd08fdcc14d67d8e65bb7a36b411f4caf11c94e1dcc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "149dd3a9bb1d85e0f9783eb893e42e2e1c0b44eea890ad7937bedc0ff7c0d5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "deaee7e48e8a9c0aacbba2e1328ee8b20e9d69ab40dafaab6e672b5aaf079e7f"
    sha256 cellar: :any,                 x86_64_linux:      "9f46a8353cb20150641cbcab774b511251fc5e23fb145f0baf2b483690a3a313"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
