class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "cf069d8973f12930a0b71170078552d54475e7e73ff6037bb94e213d6677a39b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "168e54c5a06ef827c29a6dfd01eb284a71d2e3b3873972fd37401a404329b0ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "168e54c5a06ef827c29a6dfd01eb284a71d2e3b3873972fd37401a404329b0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "168e54c5a06ef827c29a6dfd01eb284a71d2e3b3873972fd37401a404329b0ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58d3c6701d22a9f4216ba8202f55bb10e1189803d256a6a46cbc9082da4c80f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4497d2141bf52138e914ce707adf79d9682f54c7ac2102187d21aef2753585f9"
    sha256 cellar: :any,                 x86_64_linux:  "819fd7c49294c3c4fb627910adc49d743ab2894defcd77c8ab58e6043e912818"
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
