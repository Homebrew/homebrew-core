class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "cb4df41bb1491c81749d934d45afc6f527028e10f80b04c74c7a97b98eb00cf8"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cf9a28e3aeed3054193ffce8305f49d4863244bbc3e3b33f4117bc6eeac9821"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf9a28e3aeed3054193ffce8305f49d4863244bbc3e3b33f4117bc6eeac9821"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf9a28e3aeed3054193ffce8305f49d4863244bbc3e3b33f4117bc6eeac9821"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa9212b6e7a5dbbdc37b23b7941e9ce29dc55c0f0de58b883c74bd8b837bd2f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b27c2b00b682af4748c6ef1f86421774d2f1e3f92726fbecf8d59ef6bda7eed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c39ba31227b863640e97661da3c67babdcfbdd8fa0aa306fb52206207d5e8b99"
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
