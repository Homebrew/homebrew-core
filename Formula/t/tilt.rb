class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.10",
    revision: "30a6ff34a41a89f732113fd9f15de7193b9442f9"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eab77dc0edc681f3caafc90543de88a1741083b012f2acfca75079b2e2b5ae07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "478f1ed19215a6280d944862bc27da0b8d389060a6732c121c72c818a57a5ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c4bd70bf7ce42a22062d5965552c4a7a66c7cf29bcd5fe3b37f7dddfec0e0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "77345ff86baa9eb46821aefd3d53e21bfa032ffa06e54da89000d40785879e58"
    sha256 cellar: :any_skip_relocation, ventura:        "5407cc63d84ce6ee23936a0de593ad61fdb02377a53c85627d302c23d469d4ec"
    sha256 cellar: :any_skip_relocation, monterey:       "4c2f53be9843a5a1441525e9631679d6f22af74ab8b63ef8d9e10d5db9811f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca19d858dab27cb8edf93c91e96244962e2b05bfa492b84dde4674971e7e557"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/tilt"

    generate_completions_from_executable(bin/"tilt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tilt version")

    assert_match "Error: No tilt apiserver found: tilt-default", shell_output("#{bin}/tilt api-resources 2>&1", 1)
  end
end
