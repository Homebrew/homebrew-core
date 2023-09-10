class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.14.tar.gz"
  sha256 "33159846d93343da16819f7f16f9d92d19245a09a4e5f81ed398c540f2a68a51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea0f3f33eb6d3b1a791ebc675e1fb6ce0a48913e040a99db692e8a6ba19eab6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3926425aff9716998c917ca13c14c61e04f5c1397fe49a9a3b06be0484f0c268"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76164974f64224b5c499ac44b6d0b1783af1edb6b4c6fc630be0e6ffcf7eaf78"
    sha256 cellar: :any_skip_relocation, ventura:        "c7b33ef70834d9b4b6e55c264c7ecfd3fe65a3afbb9ea7375a807e7399d583f0"
    sha256 cellar: :any_skip_relocation, monterey:       "dd8be1ba978e2ca49429180045f86dd910c8e56c751435047b4884a78a9ac523"
    sha256 cellar: :any_skip_relocation, big_sur:        "565f99c4d492255593cd26a8f24deb874cb967df7467663ff6bb017c31f2e7c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecda435a078e1aeab52930686ebcd59e6f41c7f5be1b2377a23f30fdfa511a3d"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = "-X github.com/gruntwork-io/go-commons/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
