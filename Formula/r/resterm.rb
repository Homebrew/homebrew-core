class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "f89b9f54119730920ef348398e3e8c216d37cc30a8f31b0c7a2d76dda70f5ce0"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f317e1fd4711a6f32ab98917df021beb001e30ff0da3eff7690da4efd63b6fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f317e1fd4711a6f32ab98917df021beb001e30ff0da3eff7690da4efd63b6fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f317e1fd4711a6f32ab98917df021beb001e30ff0da3eff7690da4efd63b6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc690bb6f626b8656c341129bb6adb4c36abb2252bbd57e33345d1028d853b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1457f373e74b93f393ffa6b403255215c62fe13d4655b00e2c94df997c83ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb19ef8bf5c44d5f08ab84714eb48a8970a712590e2d7c417e8da5106310bda"
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
