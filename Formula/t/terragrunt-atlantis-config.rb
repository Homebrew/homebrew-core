class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https://github.com/transcend-io/terragrunt-atlantis-config"
  url "https://github.com/transcend-io/terragrunt-atlantis-config/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "a266aa0a3fd41f188551a3951af2c8c241a3956edc1eb99d81b1f9d2012923b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "522b60c0f4aed84b153f78547d3a53d6ea6f55aa7a9f1e1f8dd9acfd33f311b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522b60c0f4aed84b153f78547d3a53d6ea6f55aa7a9f1e1f8dd9acfd33f311b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "522b60c0f4aed84b153f78547d3a53d6ea6f55aa7a9f1e1f8dd9acfd33f311b7"
    sha256 cellar: :any_skip_relocation, ventura:        "518af1cbfce0795429d38b4e810bcb75466c9f5143d26a237565048ab4f44f20"
    sha256 cellar: :any_skip_relocation, monterey:       "518af1cbfce0795429d38b4e810bcb75466c9f5143d26a237565048ab4f44f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "518af1cbfce0795429d38b4e810bcb75466c9f5143d26a237565048ab4f44f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3925f39fe87e9c7aab1f60384480d79327d15d98391367340a17c708feb7890"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}/terragrunt-atlantis-config version")
  end
end
