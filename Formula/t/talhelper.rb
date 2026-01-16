class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "9c306c52f3a6e1aeeb597159c21f5c438d2b308e1c4aa8ba2d1ab9f788fd3def"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfb6ea5678f169e8ed4df77be75d3611eb5d94d549da16707954367834102093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfb6ea5678f169e8ed4df77be75d3611eb5d94d549da16707954367834102093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfb6ea5678f169e8ed4df77be75d3611eb5d94d549da16707954367834102093"
    sha256 cellar: :any_skip_relocation, sonoma:        "04514ad558f244211edd30c381fc81fd625ace38b86a33c4c8137ec04ecbbb6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa3a3e902cc5eb96c5f79e23b07e8b3261a7ab3fe09ba63958c5a06ecc8abcad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3209e0652f5a0cf9f2d4beef17cc8473b53b7656b59dd921c5c831cd891fd44d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
