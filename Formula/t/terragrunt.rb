class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.55.12.tar.gz"
  sha256 "c5f34153c52817fb73a5b2fd4d6db6b4f316b76bf54992ef9b7d8ef28d6fd681"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35b1e31eb14f030c62653b2f19dc63bff8fab16e89487e4500ae7a82dce2f1d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b9aeaf13a5547f0492782f40afd7d64d173a618c1defeededdba04bafe21131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e5e550b0f9aea16e7d6ec0814349b32b52a7d9a49183db0dbf35dfbf5ab239"
    sha256 cellar: :any_skip_relocation, sonoma:         "b243b570a705473d1791404ca492eb6a6da1937ff88396d5391a906e79bdf094"
    sha256 cellar: :any_skip_relocation, ventura:        "7f8e74b312d799155f90cf549ba6af491d5f42eb26fef5858e092685671b9850"
    sha256 cellar: :any_skip_relocation, monterey:       "f11d8eca65586dbae3811ceb4b1e25d4c09e8f319766fb587ddf272a438b5265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56749c4a3b5b4bf236f0b6d9d3e32cb5072b1c09f849daaccc52a51f5dc87af6"
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
