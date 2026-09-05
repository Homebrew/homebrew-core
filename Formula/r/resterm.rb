class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "4ca0155985af4d567615593f0176a5732b79950c281cb30cd9f82d2d573c519a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be08a28685c9d8d63c0a17d4254ca2ccd0ea758421fb8a955719560582fc1750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be08a28685c9d8d63c0a17d4254ca2ccd0ea758421fb8a955719560582fc1750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be08a28685c9d8d63c0a17d4254ca2ccd0ea758421fb8a955719560582fc1750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4b37345e7af7214b8528a6758ab65fd339b97af56e64be331ebeaf1a22799b"
    sha256 cellar: :any,                 x86_64_linux:  "5e40db2416289f7f8b2de45b410e4eccd086113b940fe75b2905126f75b6126a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
