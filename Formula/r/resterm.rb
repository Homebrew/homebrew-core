class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "2256991dde0d5f1663030951e5bc6a934301eab2e5d3cfa787495468ceacdba4"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae2ed93619c54d037e09c46bfeb0b161b35fd37036250638258101c4bcc8e0cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2ed93619c54d037e09c46bfeb0b161b35fd37036250638258101c4bcc8e0cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2ed93619c54d037e09c46bfeb0b161b35fd37036250638258101c4bcc8e0cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "db89400a34609eca13b8b585b16d61d52257a5cbcc035fb2df28a0609a710ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b49781d5fb1a4e1d633dde7a7bd5aeda6076415f68e61c51295960f7706c102c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "996da2576a76b4eb9fc00eb735ecca7e20dfc39e04a3b1bc159d316530bab424"
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
