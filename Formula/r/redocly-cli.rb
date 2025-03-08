class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.33.0.tgz"
  sha256 "9a90ff24b727b487264979e2048c714c286bd38521f7e3f1a32d0a9b0c479577"
  license "MIT"
  head "https://github.com/redocly/redocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5caa246841af00326fc03d971cb2c0cd9b5788736e0a6c788a67ee8ba84c64a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5caa246841af00326fc03d971cb2c0cd9b5788736e0a6c788a67ee8ba84c64a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5caa246841af00326fc03d971cb2c0cd9b5788736e0a6c788a67ee8ba84c64a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f3ae13bb5a7abe8d5ebd405ce9c9c7c4634705d0a4b89827c7126acc3dc069c"
    sha256 cellar: :any_skip_relocation, ventura:       "1f3ae13bb5a7abe8d5ebd405ce9c9c7c4634705d0a4b89827c7126acc3dc069c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5caa246841af00326fc03d971cb2c0cd9b5788736e0a6c788a67ee8ba84c64a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
