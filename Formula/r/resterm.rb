class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.36.3.tar.gz"
  sha256 "ff0f238cbd54c0a73855066db5f6afd4417c1641275554144a57c45060c14786"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4c809c1d2768c21d4c65d3fa6a72a60779616c06b44b9e44a2fc4db7e9f8d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c809c1d2768c21d4c65d3fa6a72a60779616c06b44b9e44a2fc4db7e9f8d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c809c1d2768c21d4c65d3fa6a72a60779616c06b44b9e44a2fc4db7e9f8d54"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b9c915f9b121656e8478a9ff189238991f56953fe21127cf9d4bd2942e8072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f58c6fb5b665cedf9ef43e2a9b22a1ef186f11ae8af30ff784a9678649743a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f00058902f5c0d8a724e9174f3199e17442d8570b8f4e01bea4e07285eeea444"
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
