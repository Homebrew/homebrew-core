class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.23.6.tar.gz"
  sha256 "87ecdc3d43bc7340078082e9b74a2cf979181cc2c83b95d3f66e30d214319e2e"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5892093b6f6c5c589b9f2754336e051b65507e8cb6f1d930c518a086937d1916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5892093b6f6c5c589b9f2754336e051b65507e8cb6f1d930c518a086937d1916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5892093b6f6c5c589b9f2754336e051b65507e8cb6f1d930c518a086937d1916"
    sha256 cellar: :any_skip_relocation, sonoma:        "804f00e597911bba8b332330d050a8b3ba2418b785a8122e31768202f8fc70cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e838609b0f1392df55efef4f070b807cc2beef18653198e16fdec07e365f335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dee1762efa496b6245025fa87f2f860aa5077e87fcde6f0989014f8c5bc606d"
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
