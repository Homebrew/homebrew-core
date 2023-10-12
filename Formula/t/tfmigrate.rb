class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.18.tar.gz"
  sha256 "d85ae2601380d35a3d9bacea8dd000635fac18ddd16cd4607359d75dd3adbc7b"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a919f5efdea71b0db281008d04b76fd2fd33502cd6dfe8b1121de6fe1c28727d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9961bea017cf055ff973661be9f938c7a6b0626c891e2f9a032d4edd7a7319cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0da0c123f97cdac75ceac3efeb0f54a05f6002c724a8918a2a40c2af8299bed"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d2282ba662e072e63b6901a672bea646e9afa070a605a35693bccf88042ca53"
    sha256 cellar: :any_skip_relocation, ventura:        "179c445165b3489dcfa0c542c418efdac024dbcf422d7093db37ba3a5728b13e"
    sha256 cellar: :any_skip_relocation, monterey:       "913dfadac0bd447ef37107c4faed79f82dea1d41f768110b0e0e2a5550af1041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b91685ecf0bdfa2436f2a949aac51925573e910a31513d7077f513caa6b7506"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # rover hard depends on terraform, so we can't run the full test
    # opentf support issue, https://github.com/minamijoyo/tfmigrate/issues/162
    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
