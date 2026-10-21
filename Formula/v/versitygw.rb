class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "0bad0aa6eb277eeba71dbad61c7e9141b748dfa1f4f1837dd43939b7ca23bf7c"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9dc0bd5b7152864b62cae490a9acd9a7e34ec5bd51a74a6b85b4cfa1a0db020"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3f0e1286521be25e6014f3cdca04c5587e9738696846aedf8d8110c77c8e796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "783fac542e9d513893e4690e000fc273df8f074740c507c32dc7528ddc4becfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14c91adf8041aa518513d9dfd403e0e75dbc0b68cd68d22472ac7332f4a872fe"
    sha256 cellar: :any,                 x86_64_linux:      "e193e1b3e05afd4051207e799e414e23f613ea15fd5ff4ecffb14ae802cdf3f3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flag \"endpoint-url\"", output
  end
end
