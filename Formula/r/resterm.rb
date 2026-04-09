class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "21fcb08115483de2ff1195ae5ac57aa62abb396529c42307dd8964e42bab4d2e"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d17aa9e54b8138721964a06be54992872de855d176e730d9dde9884b1ff8afc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d17aa9e54b8138721964a06be54992872de855d176e730d9dde9884b1ff8afc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d17aa9e54b8138721964a06be54992872de855d176e730d9dde9884b1ff8afc"
    sha256 cellar: :any_skip_relocation, sonoma:        "294ca3edbdd9f867c5655c612f2cc6dbc3d9a0a5b7da83dfb41929f33042eb82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b996501c05e45018ffc3717d225ee97c1d648e901de7e08daba7d4fbae1b711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1b7cb87eb5bd62ac58e052e4884c2329cbdcba8cacd568f94bf43ad45d8907"
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
