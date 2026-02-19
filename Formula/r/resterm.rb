class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "3bec102c67af7d65000f28fa9b4cc960acef840177f4f61249830bf9429e0b47"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6640f4f4d1cc611aac3246ad169b877459e28044307dc78b46ec491d5a304223"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6640f4f4d1cc611aac3246ad169b877459e28044307dc78b46ec491d5a304223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6640f4f4d1cc611aac3246ad169b877459e28044307dc78b46ec491d5a304223"
    sha256 cellar: :any_skip_relocation, sonoma:        "7197af0ff588e06d34d0cd67d27f3e975a61f75852c128d5ea456fb2c09093f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4158204dd0f55f1e1846285e15bd7578b5e99a38bc8b1188f31076182a44b754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f561350db7392e811c6cf8799b1a3b46fe83c93abbaed19cdfea45329423f74c"
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
