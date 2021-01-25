class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.17.2.tar.gz"
  sha256 "2281901e195b3749e9b9b2a95f74ee532ee0440ec884ab7579fd4892d3d21cf1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f2fbd69087dee0777b11140e76d038df0958b149eb55f7fd5d054d041603aea" => :big_sur
    sha256 "6de2982dac42f4f605e72de5b2160088d155735dc9df5c797c4f7cb3589264ed" => :arm64_big_sur
    sha256 "a5f08fe706d2ca47d3042285f2570d2a6e3eddcebf05ccc2967e1ec515a4e620" => :catalina
    sha256 "91ad245e91d9f0dd14f5647aedba22035d69f1ce6aeaed66f4aaa280d8743788" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
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
