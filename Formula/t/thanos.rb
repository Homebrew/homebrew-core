class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "40a9aba9bfde720f03f1db9b1458d41deadfed283b87ead26fd4ad535bdd8f83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2211d32b581452107e32edf6e47d917064862b6883bc88b075d23699dc58e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8299faeda73834ba48cdf5d5220a96a9d507f33196b12b37b1e58a703a6f02eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb4f8a30998c7f2a5382a61397024fa15e4f0bd3b8cc29b6107cfe779431c0b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "96b19d24ce9f556221a6b5f339a83829ceb13dfd6897cde7c229e2ff5a35035f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a16153e87b273509af206ba3b08c92a58685a1aa3502637b624a82df9164f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7c5c466a3dc773129c6228f236db90f96ee20c0194ee8419a39dc27b84aed3"
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
