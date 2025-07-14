class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "834c66b23007bac3233b5cf769df454bf59f1a04fd0734cd11f6c15e864c3a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6f1989c90be62c91f64c33b5dd8cab8bb805edc211cfba292e859fe05d7f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91a1e37c820537f38546ac2ee87ce04711b59a29ade083fa01e581983e50993"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c906229a2dda3ba802926c499940f852e92274ad541339e35ae203e35cf150f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a9133e06391f522b424da31ba7eebaeeb2dbecfec4ea0ec33bf7998f3de97f1"
    sha256 cellar: :any_skip_relocation, ventura:       "242ab7763ddd2808675a9f08502ac6103d53f9b56263c7391d2bdb26e9a4e9dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68784200ae295d4cdb49f534d433821d0933e417cd0efc2cfa633c507f0aab38"
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
