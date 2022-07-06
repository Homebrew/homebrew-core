class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "53148bf4c130b8e3269823afd419a89e07a9345f0aaa187b172c2b84dda4dabb"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "482e71dc85b4ea9c29d54c7e2f8ce7b43384b36928889074b2b9792c7c1c2820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e8b8ddb1fe08eb9267c4b0b9ff0d6db52077a789c2c1457f8b6bf1c3a1e192"
    sha256 cellar: :any_skip_relocation, monterey:       "36a9fbf53171243d85fcb8b09cddfc143aa4e081e7a132f03db5d29822c2cac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e89a4a4449eaf02cc4330aa10d27795bc6f5fb0abfec7c0a6ce8042f238a38db"
    sha256 cellar: :any_skip_relocation, catalina:       "475aa03adc739b5f33503d2539584f858dbece7b792ac8574d872235fcded5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af8d2c9844ddbb9a018b43309a912feabd9ac3b637a28abdd9e3974d186d4eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
