class Yaml2json < Formula
  desc "Command-line tool convert from YAML to JSON"
  homepage "https://github.com/bronze1man/yaml2json"
  url "https://github.com/bronze1man/yaml2json/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "efde12ca8b3ab7df3d3eaef35ecfb6e0d54baed33c8d553e7fd611a79c4cee04"
  license "MIT"
  head "https://github.com/bronze1man/yaml2json.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c8f34dd512a3f098cf8a17a3272e81c0b3431babe075795ec2ca02966e01d5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81fdf8b90dfbef0a48912f42db8742d4ee5542d87a3f709504821ba7c4aae7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81fdf8b90dfbef0a48912f42db8742d4ee5542d87a3f709504821ba7c4aae7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81fdf8b90dfbef0a48912f42db8742d4ee5542d87a3f709504821ba7c4aae7f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d2dd72115aaa4fc3e4cc60dc285c2d76f58283ea90241687ff3bd55fafdbe9d"
    sha256 cellar: :any_skip_relocation, ventura:       "3d2dd72115aaa4fc3e4cc60dc285c2d76f58283ea90241687ff3bd55fafdbe9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0fb799728cbc565f86a7bf1d30f4abef6d91234237653f3d209ef65c54c68a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1ad585751d061cdf59a0b4722b31fb48c34f92159426cb2e74d313db63d0b1"
  end

  depends_on "go" => :build

  conflicts_with "remarshal", because: "both install `yaml2json` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yaml2json --version 2>&1", 1)

    (testpath/"test.yaml").write <<~YAML
      firstname: John
      lastname: Doe
      age: 25

      items:
        - item: Desk
          color: black

        - item: Chair
          color: brown
    YAML

    (testpath/"expected.json").write <<~JSON
      {
        "age": 25,
        "firstname": "John",
        "lastname": "Doe",
        "items": [
          {
            "item": "Desk",
            "color": "black"
          },
          {
            "item": "Chair",
            "color": "brown"
          }
        ]
      }
    JSON

    assert_equal JSON.parse((testpath/"expected.json").read),
      JSON.parse(shell_output("#{bin}/yaml2json < #{testpath}/test.yaml"))
  end
end
