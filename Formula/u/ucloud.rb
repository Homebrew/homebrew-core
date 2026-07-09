class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "e7078ffa553e9e76d8e862ade17f7bb02523e8f7df5a1adba3f5ac876a697420"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acddff0ce864b1ae3c2eab16e4f85700f52ec277d0e222459a5174b990a99940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acddff0ce864b1ae3c2eab16e4f85700f52ec277d0e222459a5174b990a99940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acddff0ce864b1ae3c2eab16e4f85700f52ec277d0e222459a5174b990a99940"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad348d67790986caf95e16917f6fcb17cfbc9449f36efb4d995a982c4464139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aae46cad8c16ef6af292a696aa5753da26d973cde943cbe0a63dd5f233176a9"
    sha256 cellar: :any,                 x86_64_linux:  "44813a1bee1c1708de96c25b7efc5f69f9542b9831471394465c187dab79893b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ucloud/ucloud-cli/base.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
