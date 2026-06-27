class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "446d28bfca346d27509b9917c6de75db254e38119171432bb7ad15f105d19316"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f90c5f3537b7ebf48fcd326e7f55845f2e5417a49a96bfefde574d9cf6c8ea85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90c5f3537b7ebf48fcd326e7f55845f2e5417a49a96bfefde574d9cf6c8ea85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90c5f3537b7ebf48fcd326e7f55845f2e5417a49a96bfefde574d9cf6c8ea85"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfbc344d2fb9de20f6420fc8ac4bfd7a293b1b23590f91704a1acea0200e761a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab5fc229a9e91de2489e3f3858131fe9b594e0de8e13fd500fb10f2f30237d5a"
    sha256 cellar: :any,                 x86_64_linux:  "d4b20a8f54300dc723f7f6f77cb789fb1cc519a3d046522e490b687f6fd18299"
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
