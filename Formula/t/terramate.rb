class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "3a35844a18fd889e215cfb1ba514fe4606f7fd92aeb19f24d5b29b8413d6c178"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "072b68a92a243dfdac0d4e32bd9ca2c448172c0649d8802b6afbeb35cd30397f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b81ba0acd693e452682cdf152b3eba952de502f2a296cac3e05cd9ed2c4d394"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc7cd1cb25add108173300ded80be7eb96fc19d9d69dcee28575556c65693529"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8c70db18947ed7758bc12641074f94db853a75e662ad840539a2f64f90e121b"
    sha256 cellar: :any_skip_relocation, ventura:        "aacae77bce2d893dbb6a5dd9be3706c03f6543204fc028f79065c4b21752abbf"
    sha256 cellar: :any_skip_relocation, monterey:       "5916c087f37ddf027dcdfe5f7d5506ea36b9732af3e8ccf5fb3b6cd59deafabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93512ab07e958b13f3bb6bffdaf5c2feb77fdf9f8de21b6ceba8797c2cede8b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
