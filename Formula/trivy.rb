class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.34.0.tar.gz"
  sha256 "fa6c7a9754a04afb62821ece6e0128ed01c9c89a934f2f8a7d7be2e5bce7ea19"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56768a79ba750118db375866f5c511affc6a0967f5b16143710631789aa9c507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bbc9dd231a5a74a83dc9db384c5d7e4c7358253b2a2ea400916e44bb317e508"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1ff1976847b13a23df2e5b141fdbd78bc8376dbd673a4c268566798cda433d"
    sha256 cellar: :any_skip_relocation, ventura:        "fef032795f610af7875d8e256448bd17ef75a0cf40326bee495516153854bd9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b18920192cb16d1b9f4d6dea7f92f9340c9fb7523bcfc42bb32a327ea3b32e95"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c3cbe44192bd5b368415a07c30c2c40a04dc75ba496561d0ccba21389bad38d"
    sha256 cellar: :any_skip_relocation, catalina:       "66734fc8c7bd338a68e531926059356a2579b170de268e6ad1980774e9a8a5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4f49edfcdace09991cd9b32f3c66f37f23d78097840c624c86831a5d9071fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
