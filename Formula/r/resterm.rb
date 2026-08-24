class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "12e23670e08731998b1be9d1ad92731920eaae838410bed66514afb97efda5c4"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df3e0b3e1ceabaa55d62dc39042a32968cae17a0388297759ea2eb998ebd5206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df3e0b3e1ceabaa55d62dc39042a32968cae17a0388297759ea2eb998ebd5206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3e0b3e1ceabaa55d62dc39042a32968cae17a0388297759ea2eb998ebd5206"
    sha256 cellar: :any_skip_relocation, sonoma:        "1543d20f03aab36584262960c60869a24dc683187d07159f25de744e23a81247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf426390d63e9c023961b481fc0b8a2981bc1962dcb09b2e131e0bf5dc37d249"
    sha256 cellar: :any,                 x86_64_linux:  "400c3ad97af2b0e3f07198862fd0efae4c5da7e6283b9da64006b67c5c563dc2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
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
