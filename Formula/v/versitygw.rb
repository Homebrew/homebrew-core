class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "c488d6adbb40d3bcb40400fa95c8069d6720ea4fb6db590af0598fc1baa98bd5"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f50fe721276f155e875d66a66bd68f9f5acbcf83a3b740377e27d59c11d5806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f50fe721276f155e875d66a66bd68f9f5acbcf83a3b740377e27d59c11d5806"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f50fe721276f155e875d66a66bd68f9f5acbcf83a3b740377e27d59c11d5806"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6547d7b25cb8c41dbc65e899c29a2fbd3816be7350741cc90e169e41d9f219"
    sha256 cellar: :any_skip_relocation, ventura:       "3d6547d7b25cb8c41dbc65e899c29a2fbd3816be7350741cc90e169e41d9f219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545609ccc3d0920f223a3cdb3ce4d42d56e8e3726d1129236251d3a170c5d7fd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flags \"access, secret, endpoint-url\"", output
  end
end
