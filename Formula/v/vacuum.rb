class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "87995d948e22108aac91a1d1f7aaed1c8192f8ceb1838d87ffaf90645e7ac251"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5da2714a894cd7b5bd32142419157caf2fcbcd63cd00b982e20e264bc6986b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29fb965135772cf21cbbe652716f52f3d0e83b453b261aabfe22c1584fe7923d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29fcf54152c096e56256721127294ae591450ed15c198a158e5896754c360c68"
    sha256 cellar: :any_skip_relocation, sonoma:        "330aba9ac279d5e8db634c3c269d501b0ae46e8be3af60be26c2e70e0813567a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11e77255a7be2784795165ff847b63760140a88d7430f919d806dd682778789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bb75e76af38de72e91183baddef7a782b3d30403abf7e4fdb08ae7d2e63d7a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    cd "html-report/ui" do
      system "yarn", "install", "--frozen-lockfile"
      system "yarn", "build"
    end

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output
  end
end
