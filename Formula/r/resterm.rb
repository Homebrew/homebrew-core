class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "11b562b999131eb3817e278785a909411216625af1a15aa024e233d0106e9c1c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f23be564774cafe9020382cd20ee7905e55d09b4dd3d37c5d711a1627b0f9f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23be564774cafe9020382cd20ee7905e55d09b4dd3d37c5d711a1627b0f9f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23be564774cafe9020382cd20ee7905e55d09b4dd3d37c5d711a1627b0f9f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6739aac8c8d5d674d263558bf922b1fbfbfd5c34a371f3d4d10bf015dda35fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e368ac9bd5a900aa14126f89fb0e8189c66ed35808568f6db0c71ecec4baec7e"
    sha256 cellar: :any,                 x86_64_linux:  "38b099c19e44463456043826502bce3b27aba175b0a2cc67459eee1db7f04666"
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
