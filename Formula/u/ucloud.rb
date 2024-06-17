class Ucloud < Formula
  desc "Official tool for managing UCloud services"
  homepage "https://www.ucloud.cn"
  url "https://github.com/ucloud/ucloud-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a67d31b7ab9ad8845698936cdee1c6f9980c07b5018bcb741026f147c56c121"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20efca436d98b8ba064a0d171c3d3268872f1ef5631c7b779dab328fb69c3e16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3173925860ef972c70b1aa06ee3832536020f2f4be2822c2ae00d9d1ac99f8b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "223ff564e43a0740e264e0534c554fef245bd08461a51f3ae43f55f4d3e29239"
    sha256 cellar: :any_skip_relocation, sonoma:         "2980be6f7c2b4f5b09517ff8084cc9ddab8a0d462f35559f06103d1af60d0015"
    sha256 cellar: :any_skip_relocation, ventura:        "3db936aac81b5378d515d1f5a4a8e5ade5d8e9d8875a4dbbe1a9a2bc088d0f72"
    sha256 cellar: :any_skip_relocation, monterey:       "874045c5a8f9f8fafb92ef5e9122abaa6bf2b0edaf48d6416019f802e2ae3811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3921090a42dba6f1865d13de98314b7b14b025cdf600121c72984b743c813a63"
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
