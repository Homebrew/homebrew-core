class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.5.tar.gz"
  sha256 "e66b488b29666d1cb92b39107be5571d867de941f207faf1b69482aa3ded47fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee069c21a403083060421a66a31c15c0b227059c177b312669ba1b8cf9a06e96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7281b5f3d19f72345f76c7e83d6551a8c7d847f0d14dc01d10cf1431f3564edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4883b8a10bcb5fa2f7c65f97f509ac8c1b7d0e62a03d8226b37cb943b187849"
    sha256 cellar: :any_skip_relocation, sonoma:         "92d01fa73bf2909891fd4ee9a8350ed5152bf825268a365c1f38163c78fb1d44"
    sha256 cellar: :any_skip_relocation, ventura:        "70885eb24af7a5fe0bcaf29dd8935a31d74e5d7798ebc8bd2384710ccdc2833a"
    sha256 cellar: :any_skip_relocation, monterey:       "4b60ac086ed0f642a045fede7584b79f0d3d1e2535488c75bee26fd6a9a12840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b1861f313d5b9aab5cc71bf48d1053f44e5229ab0997ba8e132cf0805c4c78"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
