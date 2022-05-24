class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.26.0.tar.gz"
  sha256 "4d34e61994d8d006f9280a5dae1d57aa25e40b79bb2d3a77440978824d036cf9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397f21b7d392c0db424bb9e8f9bbf5333af600b9466ccf2aeaa0a01976d04102"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d66fee5dbe4491cf9fdcde7b3ed62bef7cb633f97dfcfa157f4f431477c8bdb0"
    sha256 cellar: :any_skip_relocation, monterey:       "b15687722e4ec3e341053df985764de7ea990b05a54f427c55927b69b9e13539"
    sha256 cellar: :any_skip_relocation, big_sur:        "efd48f1db17e924f10e3f979b3a8f5015d83954964bd4bdb0ce60a7b6562ca23"
    sha256 cellar: :any_skip_relocation, catalina:       "21090f4fd0866795c8a2daac31a96f4dc9b6f176a59c92a32d77fb5792d57313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13644bba23ea523cb162926ff1c4b037f2e44be96997b612d0a4da9775318bfa"
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
