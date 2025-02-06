class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.28.2.tgz"
  sha256 "f6eae653631fa25e19bb92fac3a76e0995d958417f8b80cd7e67cf36a5a7f15f"
  license "MIT"
  head "https://github.com/redocly/redocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e1b1022ece5e5f01027dfd58893aa3896e8a2815dba2fcb496962d80b64925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e1b1022ece5e5f01027dfd58893aa3896e8a2815dba2fcb496962d80b64925"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12e1b1022ece5e5f01027dfd58893aa3896e8a2815dba2fcb496962d80b64925"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f75bf6e9f2b00078c2063ab959089d1561ff16f7740df7cd6c689cf41e969f7"
    sha256 cellar: :any_skip_relocation, ventura:       "8f75bf6e9f2b00078c2063ab959089d1561ff16f7740df7cd6c689cf41e969f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e1b1022ece5e5f01027dfd58893aa3896e8a2815dba2fcb496962d80b64925"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/redocly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
          variables:
            Port:
              enum:
                - '8443'
                - '443'
              default: '8443'
      security: [] # SecurityRequirementList
      tags: # TagList
        - name: pets
          description: Test description
        - name: store
          description: Access to Petstore orders
      paths:
        /pets:
          get:
            summary: List all pets
            operationId: list_pets
            tags:
              - pets
            parameters:
              - name: Accept-Language
                in: header
                description: 'The language you prefer for messages. Supported values are en-AU, en-CA, en-GB, en-US'
                example: en-US
                required: false
                schema:
                  type: string
                  default: en-AU
            responses:
              '200':
                description: An paged array of pets
                headers:
                  x-next:
                    description: A link to the next page of responses
                    schema:
                      type: string
                content:
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end
