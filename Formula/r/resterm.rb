class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "cb4df41bb1491c81749d934d45afc6f527028e10f80b04c74c7a97b98eb00cf8"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87ac9baf56ffb69277ded759dc0c4131119bcd2994bf1a68c531663485e65d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ac9baf56ffb69277ded759dc0c4131119bcd2994bf1a68c531663485e65d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ac9baf56ffb69277ded759dc0c4131119bcd2994bf1a68c531663485e65d18"
    sha256 cellar: :any_skip_relocation, sonoma:        "52eb61a03de1f053cebef4ae4ff5751ecaa4a36c689e28191dc85ab7a64b3607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd830c3bcf88c7bc0be6a8f7f6f2116e17a57a6aded6edaf45d120b07f47a16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f2dcbc1427f3b3c6bc8e5ad5814c359fa44ca8d9584f02c0c0799bd93e1e0ca"
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
