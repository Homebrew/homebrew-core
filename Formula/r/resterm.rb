class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "cef0e5d33e9ab20bab6f9cac2394545369fe16f9c6f3c3801948be53c2c463f7"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3ca98733bd5ee973a349623a368e70034753d2fef11bd878f1ed64948ec888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3ca98733bd5ee973a349623a368e70034753d2fef11bd878f1ed64948ec888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3ca98733bd5ee973a349623a368e70034753d2fef11bd878f1ed64948ec888"
    sha256 cellar: :any_skip_relocation, sonoma:        "24e173c3efea96d2f970b9e60fda74f3fa0363ec0f014f53a5bf3d2d7b1b350d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b0a94cb48741652fc199481ed5feba8a6e19ac50daaff63331a16e9d5ebeb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961d32819798987ca3c3a56a2559f51121ef5ba028d774a1fd8ed93c9c1f36c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
