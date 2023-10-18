class Tilt < Formula
  desc "Define your dev environment as code. For microservice apps on Kubernetes"
  homepage "https://tilt.dev/"
  url "https://github.com/tilt-dev/tilt.git",
    tag:      "v0.33.6",
    revision: "9ea391c65a22dc9030de15d2996d1c7a45987ed5"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/tilt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "250a1f8745e5803ae5276745e3c8b6c42a7c95e3ac9e1bed8a13ff16232f1381"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "613bb66b786e081efcf50018b2156600630575c0fa04a1bacd5377ad2fd7457b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90fc948060afdb32f18af7b3383776c8466a3fcf15b7c9c008fc546d6a2739ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f225cdc146aa6fca6b56f7475a79eb4fd8d499714374bbb6337b354f1ba7637"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3f9a42a4971dc009af18bf275bb91ee89853d00f85753ea836c078883de1c1"
    sha256 cellar: :any_skip_relocation, monterey:       "506c350a8cadb3d81315d79e971cdc866f2d5925d48a328de8cafa144466091c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5338f8e91deef66a753d4d6c807abcee7aaf4772a15ceb5842e3ce358d36095d"
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
