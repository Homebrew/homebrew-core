class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "026f20f9ed0530922efa648db2583118bc49b2df4fcd2458b8d214bf8d1ea584"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c05bf63b9282fc3e16e61479faab1b29999a1d8cbeec1de9a4c99b1b0b0f648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c05bf63b9282fc3e16e61479faab1b29999a1d8cbeec1de9a4c99b1b0b0f648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c05bf63b9282fc3e16e61479faab1b29999a1d8cbeec1de9a4c99b1b0b0f648"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6ac9507c40d5ae034e027d3cc9b598e29630d9f1e9cd8cb717bf29694d1f20f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c89ce6468f5646bf122948318a182e7b674ae08f563dbe4c410152eb0ab36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b1be523a91f38daa394cd7057ff950cb6534e6f6168e9f248338f564c39732"
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
