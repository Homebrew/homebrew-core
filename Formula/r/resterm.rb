class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "fdcf4b455d913ec8c32a123e70699b15290a164c4aaf26e553c16cb6c12f69bf"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d644b3c76bf59e553d5a8b45151b4c4481c8c73c88950d87775582b1abfb7997"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d644b3c76bf59e553d5a8b45151b4c4481c8c73c88950d87775582b1abfb7997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d644b3c76bf59e553d5a8b45151b4c4481c8c73c88950d87775582b1abfb7997"
    sha256 cellar: :any_skip_relocation, sonoma:        "bde0f5bcf3ee7a6d819722a840dc33dda40f100a23baedb16e7c3821bc117e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4c6651e5a5ae86d78bb10796aa9b5beccadd972fff4e6b7122ea0fcaf3c9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcae8589b7bef3dbbc93e715d63574c32463e7d8ea8d9e683f78e25d415403c8"
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
