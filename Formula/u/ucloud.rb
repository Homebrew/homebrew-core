class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "046384f660076a0fe235f18c6916c762c2d6f47a441ab037e64313467c0a2202"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24962ad64d5634087f18a8283c90b84a07594c403720da75149512f96702f84f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24962ad64d5634087f18a8283c90b84a07594c403720da75149512f96702f84f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24962ad64d5634087f18a8283c90b84a07594c403720da75149512f96702f84f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a124802d5862c328432f3bcb442151f574542aeb1042187be23bb938ee4326b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ce8dcefee20966629e65d9c896d33cf48aa2b69d8726969623215fa6059e1a"
    sha256 cellar: :any,                 x86_64_linux:  "2b767064b1953cc677dff0797c3ed24c8ace56a179ecb290a7039af07bfcc3e2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ucloud/ucloud-cli/cmd/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"ucloud", "config", "--project-id", "org-test", "--profile", "default", "--active", "true"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud --version")
  end
end
