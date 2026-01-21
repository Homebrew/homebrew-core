class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "d41b50c3d6d315e6bb1b2f40a7cf4ce6952e5b392c721e65ad3b1f8d5d60c7fd"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcd742d893b6e082ca632548b3f63ce727bbb0da0c64a93626eb8a70daf1a7fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411f302ec6e62337b1b2da21ef682ba9a9c45e439d9ff882c2861bda0f0482de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b819151bdca419c8b8ee95e7bfa2a48a2b36b0d4e063c9a1e80d29f2be1729f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea39408dbaead635874d27cb39eb3fd53e22fc7ea935e9388cc0323a4d8e348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2f752d09f1485dce3cc9c827d8677aaa97cb8ad2e82721f818482edca3b93d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c04580ff4368a74baa985c344cc78b49bc5fd455e037947e648ec586d09925be"
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
