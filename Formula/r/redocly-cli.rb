class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.14.5.tgz"
  sha256 "718bebeaca68c0bb083cdf2abc577acf2bf8b82f197189c59b2cb48c6e0e9966"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "623f31f75ea9828248b237816af1a8cfa62d24545c7953af49d8ce258ff6fdd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10be601b0c07379f5bbf60ed18fae8df4d1b4240920232bd9ffa86b1533cb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10be601b0c07379f5bbf60ed18fae8df4d1b4240920232bd9ffa86b1533cb42"
    sha256 cellar: :any_skip_relocation, sonoma:        "69886fdf9b40a34c6b9b01ec2130ecbc6ffd59d140fbcd0a5180b6fb979cf1a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11abd1b0f64340d1a121f70cf897e9f898192056b5bacb7f35425c29b1104466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11abd1b0f64340d1a121f70cf897e9f898192056b5bacb7f35425c29b1104466"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@redocly/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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
