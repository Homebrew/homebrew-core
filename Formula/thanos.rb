class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.19.0.tar.gz"
  sha256 "5412ffb758590a7a310bbaade20b31e98da23bbd861549ec3f227c8585ef0dae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab70eee94e083954cf7ed382b78d442a9c9ed0d114e1e152bbb35b1fc33f251b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b0454e55d729ecaa626eaf538ef52f89795ab047e46954292abce064ca7f174"
    sha256 cellar: :any_skip_relocation, catalina:      "a5542efecf2ca1aa0259bbf1ed068e2e4b0c9a61e0abf925a584beaaaec135ae"
    sha256 cellar: :any_skip_relocation, mojave:        "93cefede1f18ff6c15924d3461823f70a8049375145901f7cda05b0d0fd4f951"
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
