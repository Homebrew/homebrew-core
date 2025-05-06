class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "2c9fef368e612c24d3270b57685e8025dfc0cdf6c3717cce801483e6ec499104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3acd83c72283c5fb2993ae05d0aacadaa7776c1724b0e20ff8620b3187a4fbd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69b8eaaf4a0d6ef60c4827144d20b787db7a94854e3a20715187babffadbf92c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b2549cbe1a0136d8e297f7a654007f05b206422de631be4453cf206b425863f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93862084a575ebab8e795ec3f78ed4ab00cf2ba90087b09e537c696f89762cb1"
    sha256 cellar: :any_skip_relocation, ventura:       "1a058d173ff24cb2c8b384e5dd1c05bf35be149534003f89de6465ffe50a905a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "132fed8abc06556b1c3fd1d5927c4586ef2023c102814c2ba1963ecb6ae552e7"
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
