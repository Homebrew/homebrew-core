class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.13",
    revision: "050162248092ae90d3aa6a9ba8a62f9cb9311bac"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f08445dadfa14df3c4f64dec516125ee3728090a56fdbe71019b06903c9b86d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d12b837e24597ac8b66256839d1ddb1a3ccc44fad3b7904eff9c9cbe010f289a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b4bc8967a137eba752358c92e1a7e34343d6161f2d0b74eabed96228e091f66"
    sha256 cellar: :any_skip_relocation, sonoma:         "798776c9ca5ec15bc8c33234f15a01a5b79d3d42020ccbe5d396c100694304b5"
    sha256 cellar: :any_skip_relocation, ventura:        "d719228b22daea1c5b23f54ccaad29f1008e43f75d1787cc3bb5908fe718045c"
    sha256 cellar: :any_skip_relocation, monterey:       "3a73d1702b148ab2d644cbfd6b8c4cf751e213e6572a803041a294b5d2a67cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61973993463f7947b7c80dfee1f911f467cd403974e62f329af6444b91767526"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # bundling the frontend assets first will allow them to be embedded into
    # the final build
    system "yarn", "config", "set", "ignore-engines", "true" # allow our newer node
    system "make", "build-js"

    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
