class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "4cd02ccdda40cd7b91e8d8d32a26eaaa2d82302082eaa86a6a9d485a5e5eb3f9"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dee5c59ab75c19415f80706753e118fee4c0ced01d3b775129d8d8eb076fa7fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dee5c59ab75c19415f80706753e118fee4c0ced01d3b775129d8d8eb076fa7fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee5c59ab75c19415f80706753e118fee4c0ced01d3b775129d8d8eb076fa7fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dee5c59ab75c19415f80706753e118fee4c0ced01d3b775129d8d8eb076fa7fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5fa72815679068c8398dd6dfbc9f7ac3c646a88bedd66492874fc6a8048f809"
    sha256 cellar: :any_skip_relocation, ventura:        "d5fa72815679068c8398dd6dfbc9f7ac3c646a88bedd66492874fc6a8048f809"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fa72815679068c8398dd6dfbc9f7ac3c646a88bedd66492874fc6a8048f809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8fe05dc35eb0b2d48eb0039f8da965aea71e09bbaf9cbfc4b820eb52f2fd3c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not yet set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
