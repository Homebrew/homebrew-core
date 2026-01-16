class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4b70919ce47d14fe92496be1686ac2264a23a5f898cba5faff1bcc0f38363686"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5957d48f407072d115c3cad17b814e36e44083d12f88b7453db1b6ecc7589cdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad072862ba359124e3ed02553063f25772337376aafe978c3fc6633f1c3be14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad072862ba359124e3ed02553063f25772337376aafe978c3fc6633f1c3be14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bad072862ba359124e3ed02553063f25772337376aafe978c3fc6633f1c3be14"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa91bbe59f176048fa024ca08093692f67fcd8c815ef0288d00a8e631254d272"
    sha256 cellar: :any_skip_relocation, ventura:       "aa91bbe59f176048fa024ca08093692f67fcd8c815ef0288d00a8e631254d272"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feb403aaf56c604a31e3f49b6c7d05807b0c9ce4924ca4cad5f9cf9d8d41607b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8461b7142d140881f42abb9c283555dd751565fd50d33072c344ed3e6b02602f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
