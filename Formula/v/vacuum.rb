class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "272fd544536d9ed41806b15bae65a74cae1bac931a6af5a356e94b71d9ed4298"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2662117bfba3243a9e8a113397be726935820c524155d2acab51a188a8c069f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4c180fc08a81cc10ab5522c9471e7ba6dfd78ac49928b144b934474dde45399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f753b05daf90ea80dc53129f7bd928cb9621e0ba7d44c81fa143560b98d2bed6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb5f97729e14115fbec67c7cc44f4ef95903ae4d3f614fb3816c99a82e7099c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b1fa029d94d308969d773ca9e8dd264a404e22782bb61edc5dd619959622d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fe2ace0ac3b6ad14b2b23b70f0f880a46f3164be6a5178d54c09a3dd926a31c"
  end

  depends_on "go" => :build

  def install
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
